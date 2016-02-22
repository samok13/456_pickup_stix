class ArtistsController < ApplicationController

  def index
    @artists = Artist.all
  end

  def show
    @artist = Artist.find(params[:id])
     if current_user
      @playlist_selection = PlaylistSelection.new
    end
  end

private
  def whitelisted_playlist_params
     params.require(:artist).permit(:name)
  end

end
