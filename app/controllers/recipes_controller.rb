require 'rake'
RecipeBook::Application.load_tasks


class RecipesController < ApplicationController

  before_action :require_current_user, :except => [:index, :show, :create]


  def create
    if params
      @new_recipe = current_user.recipes.create!
      #@new_recipe.ingredients.create!
      #@new_recipe.instructions.create!
    else
      old_recipe = Recipe.find(params[:id])
      @new_recipe = old_recipe.copy_recipe(current_user)
    end

    @new_recipe.save!

    respond_to do |format|
      format.json { render json: @new_recipe.to_json(:include => [:instructions, :ingredients]), status: 201 }
    end
  end


  def index
    @recipes = Recipe.where("user_id = ?", current_user.id)

    respond_to do |format|
      if @recipes
        format.json { render json: @recipes }
      else
        format.json { render nothing: true, status: 404 }
      end
    end
  end


  def show
    @recipe = Recipe.where(:id => params[:id])[0]
    @notes_ingredients = @recipe.ingredients.collect(&:notes).flatten
    @notes_instructions = @recipe.instructions.collect(&:notes).flatten

    if @recipe
      respond_to do |format|
        format.json {
          render json: @recipe.to_json(:include => [
            {:instructions => {:include => :notes}},
            {:ingredients => {:include => :notes}}
          ]),
          status: 200
        }
        format.pdf { render pdf: "recipe", layout: "pdf.html.erb", encoding: 'utf8' }
      end

    else
      respond_to do |format|
        format.json { render nothing: true, status: 404 }
        format.pdf { render nothing: true, status: 404 }
      end
    end

  end


  def update
    @recipe = Recipe.where(:id => params[:id])[0]

    if @recipe.update(recipe_params)
      if params['$name'] === 'scraper'
        site = URI.parse(params[:url]).host

        if site == "cooking.nytimes.com"
          Rake::Task['recipes:scrape_nyt'].invoke(@recipe)
          Rake::Task['recipes:scrape_nyt'].reenable
        elsif site == "www.epicurious.com"
          Rake::Task['recipes:scrape_epicurious'].invoke(@recipe)
          Rake::Task['recipes:scrape_epicurious'].reenable
        elsif site == "www.foodnetwork.com"
          Rake::Task['recipes:scrape_fn'].invoke(@recipe)
          Rake::Task['recipes:scrape_fn'].reenable
        end
        @recipe = Recipe.where(:id => params[:id])[0]
      end

      respond_to do |format|
        format.json { render json: @recipe.to_json(:include => [:instructions, :ingredients]), status: 200 }
      end

    else
      respond_to do |format|
        format.json { render :nothing => :true, :status => 422 }
      end
    end
  end


  def destroy
    @recipe = Recipe.find(params[:id])

    if @recipe.destroy
      respond_to do |format|
        format.json { render :nothing => :true, :status => 204 }
      end
    else
      respond_to do |format|
        format.json { render :nothing => :true, :status => 422 }
      end
    end

  end


  private


    def recipe_params
      params.require(:recipe).permit( :title,
                                      :author,
                                      :photo_url,
                                      :description,
                                      :url,
                                      :ingredients_attributes => [:id, :body, :recipe_id],
                                      :instructions_attributes => [:id, :body, :recipe_id])
    end


    def require_current_user
      recipe = Recipe.find(params[:id])
      unless recipe.user == current_user
        flash.now[:danger] = "You're not authorized to do this!"
        respond_to do |format|
          format.json { render :nothing => :true, :status => 401 }
        end
      end
    end

end
