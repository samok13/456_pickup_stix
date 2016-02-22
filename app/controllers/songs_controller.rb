class SongsController < ApplicationController
   before_action :require_login, except: [:show]
  
  
  def show
    @song = Song.find(params[:id])
    @playlist_selection = PlaylistSelection.new
  end
end
