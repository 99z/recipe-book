class NotesController < ApplicationController

  before_action :require_current_user

  def update
    @note = Note.where(:id => params[:id])[0]

    if @note.update(note_params)
      respond_to do |format|
        format.json { render json: @note.to_json, status: 200 }
      end
    else
      respond_to do |format|
        format.json { render :nothing => :true, :status => 422 }
      end
    end
  end


  private

    def note_params
      params.require(:note).permit(:body)
    end

    def require_current_user
      note = Note.find(params[:id])
      unless note.notable.recipe.user == current_user
        flash.now[:danger] = "You're not authorized to do this!"
        respond_to do |format|
          format.json { render :nothing => :true, :status => 401 }
        end
      end
    end

end
