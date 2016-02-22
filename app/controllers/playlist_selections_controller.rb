class PlaylistSelectionsController < ApplicationController
  before_action :require_login, except: [:show]

  def create
    if signed_in_user?
      @playlist_selection = PlaylistSelection.new(playlist_selection_params)
      if @playlist_selection.save
        flash[:success] = ' Your song has been added.'
        redirect_to :back
      else
        flash[:error] = ' Your song could not be added.' +
        @playlist_selection.errors.full_messages.join(',')
        redirect_to :back
      end
    else
      flash[:error] = "You already are a user."
      redirect_to login_path
    end
  end


  def destroy
    if signed_in_user?
      @playlist_selection = PlaylistSelection.find_by_id(params[:id])
      if @playlist_selection && @playlist_selection.destroy
        flash[:success] = "User has been deleted."
        redirect_to :back
      else
        flash[:error] = ' Your song could not be added.' +
        (@playlist_selection ? @playlist_selection.errors.full_messages.join(',') : "")
        redirect_to :back
      end
    else
      flash[:error] = "You must be logged in for this action."
      redirect_to login_path
    end
  end


private

  def playlist_selection_params
    params.require(:playlist_selection).permit(:song_id, :playlist_id)
  end


end
