require 'rake'
RecipeBook::Application.load_tasks


class RecipesController < ApplicationController


  def create
    @recipe = current_user.recipes.create!
    @recipe.instructions.create!
    @recipe.ingredients.create!

    respond_to do |format|
      format.json { render json: @recipe.to_json(:include => [:instructions, :ingredients]), status: 201 }
    end
  end


  def show
    @recipe = Recipe.where(:id => params[:id])[0]

    if @recipe
      respond_to do |format|
        format.json { render json: @recipe.to_json(:include => [:instructions, :ingredients]), status: 200 }
      end
    else
      respond_to do |format|
        format.json { render nothing: true, status: 404 }
      end
    end

  end


  def update
    @recipe = Recipe.where(:id => params[:id])[0]
    puts "~~~~"
    puts recipe_params
    puts "~~~~"

    if @recipe.update(recipe_params)
      if params['$name'] === 'scraper'
        Rake::Task['recipes:scrape_nyt'].invoke(@recipe)
        Rake::Task['recipes:scrape_nyt'].reenable
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


  private

    def recipe_params
      params.require(:recipe).permit( :title,
                                      :author,
                                      :photo_url,
                                      :description,
                                      :url,
                                      :ingredients_attributes => [:id, :name],
                                      :instructions_attributes => [:id, :body])
    end

end
