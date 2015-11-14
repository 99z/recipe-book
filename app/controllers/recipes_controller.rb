class RecipesController < ApplicationController

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
    @recipe = Recipe.where(:id => params[:id])

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
    # need to pass recipe object to task
    # runs task
    # respond with new recipe as json
  end

end
