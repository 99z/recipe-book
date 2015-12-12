class SharesController < ApplicationController

  def create
    @share = current_user.outgoing_shares.build(share_params)

    respond_to do |format|
      if @share.save
        format.json { render json: @share, status: 200 }
      else
        format.json { render nothing: true, status: 404 }
      end
    end

  end


  def destroy
  end


  private

    def share_params
      params.require(:share).permit(:recipient_id, :recipe_id)
    end

end
