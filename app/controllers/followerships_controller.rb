class FollowershipsController < ApplicationController

  def index
    @followerships = Followership.where("follower_id = ? OR followed_id = ?", current_user.id, current_user.id)

    respond_to do |format|
      if @followerships
        format.json { render json: @followerships }
      else
        format.json { render nothing: true, status: 404 }
      end
    end
  end

  def destroy
    @followership = Followership.find(params[:id])

    if @followership.destroy
      respond_to do |format|
        format.json { render :nothing => :true, :status => 204 }
      end
    else
      respond_to do |format|
        format.json { render :nothing => :true, :status => 422 }
      end
    end
  end

end
