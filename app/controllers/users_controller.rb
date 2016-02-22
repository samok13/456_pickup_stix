class UsersController < ApplicationController
before_action :require_login, only: [:edit, :update, :destroy]
before_action :require_current_user, :only => [:edit, :update, :destroy]


  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    if signed_in_user?
      flash[:error] = "You already are a user."
      redirect_to root_path
    else
       @user = User.new(whitelisted_user_params)
      if @user.save
        sign_in(@user)  
        flash[:success] = "Created new user!"
        redirect_to user_path(@user)
      else
        flash[:error] = "Failed to Create User!" + 
          @user.errors.full_messages.join(', ')
        render :new
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])
    if @user.update(whitelisted_user_params)
      flash[:success] = "User has been updated."
      redirect_to user_path(@user)
    else
      flash[:error] = "Unable to update user."
      @user.errors.full_messages
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "User has been deleted."
    end
    redirect_to root_path
  end

  private
  def whitelisted_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end
