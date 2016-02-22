require 'rails_helper'

describe SessionsController do
  let(:user) { create(:user) }
  let(:post_create_session) do
    post :create,
        :email => user.email,
        :password => user.password
  end

  before do
    user
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end


  describe 'POST #create' do
    it 'signs the user in when the data is valid' do
      post_create_session
      expect(response).to redirect_to(user)
    end


    it 'sets the #current_user to the signed in user' do
      post_create_session
      expect(controller.send(:current_user)).to eq(user)
    end


    it 'renders the login when data is invalid' do
      post :create,
        :email => 'BOOM!',
        :password => 'BOOM!'

      expect(response).to render_template(:new)
    end
  end


  describe 'DELETE #destroy' do
    before do
      create_session(user)
    end

    it 'signs the user out when the user was signed in' do
      delete :destroy
      expect(controller.send(:current_user)).to be_nil
    end
  end
end

