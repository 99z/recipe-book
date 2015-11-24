class UsersController < ApplicationController

  def index
    # @users = User.where("id != ?", current_user.id)
    @users = User.all

    respond_to do |format|
      if @users
        format.json { render json: @users }
      else
        format.json { render nothing: true, status: 404 }
      end
    end
  end

  def destroy
    @user = current_user

    respond_to do |format|
      if @user.destroy
        format.json { render json: @user }
      else
        format.json { render nothing: true, status: 404 }
      end
    end
  end

  def show
    @user = User.where("id == ?", params[:id])[0]

    respond_to do |format|
      if @user
        format.json { render json: @user }
      else
        format.json { render nothing: true, status: 404 }
      end
    end
  end

end
