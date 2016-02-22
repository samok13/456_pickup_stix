class PlaylistsController < ApplicationController
before_action :require_login, :only => [:edit, :update, :destroy, :new, :create]

  def show
    @playlist = Playlist.find(params[:id])
  end


  def new
    @playlist = Playlist.new
  end

  def create
    new_params = whitelisted_playlist_params.to_h
    new_params[:user_id] = current_user.id
    @playlist = Playlist.new(new_params)
    if @playlist.save
      flash[:success] = "Playlist has been saved."
      redirect_to playlist_path(@playlist)
    else
      flash.now[:error] = "Playlist not saved." +
      @playlist.errors.full_messages.join(',')
      render :new
    end
  end

  def edit
    @playlist = Playlist.find(params[:id])
  end

  def update
    @playlist = Playlist.find(params[:id])
    if @playlist.update(whitelisted_playlist_params)
      flash[:success] = "Playlist has been updated."
      redirect_to playlist_path(@playlist)
    else
      flash[:error] = "Playlist not updated."
      render :edit
    end
  end

  def index
    @playists = Playlist.all
  end

  def destroy
    @playlist = Playlist.find_by_id(params[:id])
    if @playlist && @playlist.destroy
      flash[:notice] = "Playlist has been deleted."
      redirect_to current_user
    else
      flash.now[:error] = "Playlist could not be deleted."
      redirect_to :back
    end
  end



  private
  def whitelisted_playlist_params
     params.require(:playlist).permit(:name)
  end

end
