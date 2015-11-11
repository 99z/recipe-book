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

end
