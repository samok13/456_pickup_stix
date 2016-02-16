class UsersController < ApplicationController
before_action :require_login, :except => [:new, :create]
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
     @user = User.new(whitelisted_user_params)
    if @user.save
      sign_in(@user)  
      flash[:success] = "Created new user!"
      redirect_to @user
    else
      flash.now[:error] = "Failed to Create User!"
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if current_user.update(whitelisted_user_params)
      flash[:success] = "User has been updated."
      redirect_to current_user
    else
      flash[:error] = "Unable to update user."
      @user.errors.messages
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "User has been deleted."
    end
    redirect_to login_path
  end

  private
  def whitelisted_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

end
