class ProfilesController < ApplicationController

  def index
    @profiles = Profile.all

    respond_to do |format|
      if @profiles
        format.json { render json: @profiles }
      else
        format.json { render nothing: true, status: 404 }
      end
    end
  end

  def show

  end

  def update
    @profile = Profile.find_by_id(params[:id])

    respond_to do |format|
      if @profile.update(whitelisted_profile_params)
        format.json { render json: @profile }
      else
        format.json { render nothing: true, status: 404 }
      end
    end
  end

  private

  def whitelisted_profile_params
    params.require(:profile).permit(:user_id, :first_name, :last_name, :location)
  end

end
