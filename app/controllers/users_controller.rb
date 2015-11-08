class UsersController < ApplicationController

  def index
    @users = User.where("id != ?", current_user.id)

    respond_to do |format|
      if @users
        format.json { render json: @users }
      else
        format.json { render nothing: true, status: 404 }
      end
    end
  end
  
end
