class InstructionsController < ApplicationController

  before_action :require_recipe_owner


  def create
    @recipe = Recipe.find(params[:recipe_id])
    @instruction = @recipe.instructions.create

    if @instruction
      respond_to do |format|
        format.json { render json: @instruction.to_json, status: 200 }
      end

    else
      respond_to do |format|
        format.json { render :nothing => :true, :status => 422 }
      end
    end

  end


  private

    def require_recipe_owner
      recipe = Recipe.find(params[:recipe_id])
      unless recipe.user == current_user
        flash.now[:danger] = "You're not authorized to do this!"
        respond_to do |format|
          format.json { render :nothing => :true, :status => 401 }
        end
      end
    end

end
