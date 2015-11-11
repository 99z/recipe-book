class RecipesController < ApplicationController

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

end
