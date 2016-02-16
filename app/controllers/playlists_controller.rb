class PlaylistsController < ApplicationController
before_action :require_login, :only => [:edit, :update]

  def show
    @playlist = Playlist.find(params[:id])
  end

  def new
    @playlist = Playlist.new
  end

  def create
    @playlist = Playlist.new(whitelisted_playlist_params)
    if @playlist.save
      flash[:success] = "Playlist has been saved."
      redirect_to playlist_path(@playlist)
    else
      flash[:error] = "Playlist not saved."
      @playlist.errors.messages
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

  private
  def whitelisted_playlist_params
     params.require(:playlist).permit(:name, :user_id)
  end

end
