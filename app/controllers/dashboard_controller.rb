class DashboardController < ApplicationController

  before_action :require_current_user, :except => [:show, :create]

  def index
  end

  def require_current_user
    unless current_user
      flash.now[:danger] = "You're not authorized to do this!"
      respond_to do |format|
        format.json { render :nothing => :true, :status => 401 }
      end
    end
  end

end
