class BookmarksController < ApplicationController
before_action :require_login, :only => [:create, :destroy]

def new
end

def create
  
  if signed_in_user?
    
    @bookmark = Bookmark.new(:bookmarkable_type => params[:bookmarkable_type], :bookmarkable_id => params[:bookmarkable_id], :user_id => current_user.id)

    if @bookmark.save
      flash[:success] = "Bookmark has been saved."
      redirect_to :back
    else
      flash[:error] = "Bookmark has not saved." +
      @bookmark.errors.full_messages.join(',')
      redirect_to :back
    end
  else
    flash[:error] = "Bookmark has not saved."
    redirect_to login_path
  end
end

def destroy
  @bookmark = Bookmark.find_by_id(params[:id])
    if @bookmark && @bookmark.destroy
      flash[:notice] = "Bookmark has been deleted."
    else
      flash[:error] = "Bookmark has not been deleted."
    end
    redirect_to :back
end


end
