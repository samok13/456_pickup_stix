require 'rails_helper'

describe ApplicationController do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }


  controller do
    before_action :require_login, :only => [:index]
    before_action :require_current_user, :only => [:show]
    before_action :require_logout, :only => [:new]

    def index
      render :text => 'Index'
    end

    def show
      render :text => 'Show'
    end

    def new
      render :text => 'New'
    end
  end


  # ----------------------------------------
  # #current_user
  # ----------------------------------------

  describe '#current_user' do
    it 'returns the user currently signed in' do
      create_session(user)
      expect(controller.send(:current_user)).to eq(user)
    end


    it 'returns nil if there is no user signed in' do
      expect(controller.send(:current_user)).to be_nil
    end
  end


  # ----------------------------------------
  # #signed_in_user?
  # ----------------------------------------

  describe '#signed_in_user?' do
    it 'returns true when there is a user signed in' do
      create_session(user)
      expect(controller.send(:signed_in_user?)).to eq(true)
    end


    it 'returns false when there is not a user signed in' do
      expect(controller.send(:signed_in_user?)).to eq(false)
    end
  end


  # ----------------------------------------
  # #is_current_user?
  # ----------------------------------------

  describe '#is_current_user?' do
    it 'returns false if the user is not signed in' do
      expect(controller.send(:is_current_user?, user)).to eq(false)
    end


    it 'returns false if the user is not the signed in user' do
      create_session(other_user)
      expect(controller.send(:is_current_user?, user)).to eq(false)
    end


    it 'returns true if th user is signed in and the currently signed in user' do
      create_session(user)
      expect(controller.send(:is_current_user?, user)).to eq(true)
    end
  end


  # ----------------------------------------
  # #sign_in
  # ----------------------------------------

  describe '#sign_in' do
    it 'signs in the given user' do
      controller.send(:sign_in, user)
      expect(controller.send(:current_user)).to eq(user)
    end
  end


  # ----------------------------------------
  # #sign_out
  # ----------------------------------------

  describe '#sign_out' do
    it 'it signs out the current user' do
      create_session(user)
      controller.send(:sign_out)
      expect(controller.send(:signed_in_user?)).to eq(false)
    end
  end


  # ----------------------------------------
  # #require_login
  # ----------------------------------------

  describe '#require_login' do
    it 'does nothing if the user is signed in' do
      create_session(user)
      get :index
      expect(response).to_not redirect_to root_path
    end


    it 'redirects to login path if the user is not signed in' do
      get :index
      expect(response).to redirect_to login_path
    end
  end
end




