class NewsfeedsController < ApplicationController

  def index
    @newsfeed = current_user.following_activity_recent

    respond_to do |format|
      if @newsfeed
        format.json { render json: @newsfeed }
      else
        format.json { render nothing: true, status: 404 }
      end
    end
  end

end
