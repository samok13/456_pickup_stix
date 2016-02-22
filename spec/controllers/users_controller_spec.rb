require 'rails_helper'

describe UsersController do
  let(:user) { create(:user) }


  before do
    set_http_referer
  end

  # ----------------------------------------
  # GET #show
  # ----------------------------------------

  describe 'GET #show' do
    let(:get_show) { get :show, :id => user.id }


    before do
      user
      get_show
    end


    it 'renders the show template' do
      expect(response).to render_template(:show)
    end


    it 'sets an instance variable to the user' do
      expect(assigns[:user]).to eq(user)
    end
  end

  # ----------------------------------------
  # GET #new
  # ----------------------------------------

  describe 'GET #new' do
    before do
      create_session(user)
      get :new
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end


    it 'sets an instance variable to a new user' do
      expect(assigns[:user]).to be_an_instance_of(User)
      expect(assigns[:user]).to_not be_persisted
    end
  end

  # ----------------------------------------
  # GET #edit
  # ----------------------------------------

  describe 'GET #edit' do
    let(:get_edit) { get :edit, :id => user.id }


    context 'the user IS logged in' do
      before do
        create_session(user)
        get_edit
      end


      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end


      it 'sets an instance variable to the user' do
        expect(assigns[:user]).to eq(user)
      end
    end


    context 'the user is NOT logged in' do
      before do
        get_edit
      end

      it 'redirects to login' do
        expect(response).to redirect_to(login_path)
      end


      it 'sets an error flash' do
        expect(flash_error).to_not be_nil
      end
    end
  end

  # ----------------------------------------
  # POST #create
  # ----------------------------------------

  describe 'POST #create' do
    let(:post_create_valid) do
      post :create,
        :user => {
          :first_name => 'Foo',
          :last_name => 'Bar',
          :email => 'foo@bar.com',
          :password => 'password',
          :password_confirmation => 'password'
        }
    end

    let(:post_create_invalid) do
      post :create,
        :user => {
          :first_name => '',
          :last_name => '',
          :email => '',
          :password => '',
          :password_confirmation => ''
        }
    end


    context 'the user is NOT logged in' do
      context 'the data is valid' do
        it 'creates the user' do
          expect { post_create_valid }.to change(User, :count).by(1)
        end


        it 'redirects to the user' do
          post_create_valid
          user = User.last
          expect(response).to redirect_to(user)
        end


        it 'sets a success flash' do
          post_create_valid
          expect(flash_success).to_not be_nil
        end
      end


      context 'the data is invalid' do
        it 'does NOT create the user' do
          expect { post_create_invalid }.to change(User, :count).by(0)
        end


        it 'renders the new template' do
          post_create_invalid
          expect(response).to render_template(:new)
        end


        it 'sets an error flash' do
          post_create_invalid
          expect(flash_error).to_not be_nil
        end
      end
    end


    context 'the user IS logged in' do
      before do
        create_session(user)
        post_create_valid
      end


      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end


      it 'sets an error flash' do
        expect(flash_error).to_not be_nil
      end
    end
  end

  # ----------------------------------------
  # PUT #update
  # ----------------------------------------

  describe 'PUT #update' do
    let(:put_update_valid) do
      put :update,
        :id => user.id,
        :user => {
          :first_name => 'Foo',
          :last_name => 'Bar',
          :email => 'foo@bar.com',
          :password => 'password',
          :password_confirmation => 'password'
        }
    end

    let(:put_update_invalid) do
      put :update,
        :id => user.id,
        :user => {
          :first_name => '',
          :last_name => '',
          :email => '',
          :password => '',
          :password_confirmation => ''
        }
    end


    before do
      user
    end


    context 'the user IS logged in' do

      before do
        create_session(user)
      end


      context 'the data is valid' do
        before do
          put_update_valid
          user.reload
        end


        it 'updates the user' do
          expect(user.first_name).to eq('Foo')
        end


        it 'redirects to the user' do
          expect(response).to redirect_to(user)
        end


        it 'sets a success flash' do
          expect(flash_success).to_not be_nil
        end
      end


      context 'the data is invalid' do
        before do
          put_update_invalid
        end


        it 'does not update the user' do
          expect(user.name).to_not eq('Foo')
        end


        it 'renders the edit template' do
          expect(response).to render_template(:edit)
        end


        it 'sets an error flash' do
          expect(flash_error).to_not be_nil
        end
      end
    end


    context 'the user is NOT logged in' do
      before do
        put_update_valid
      end


      it 'redirects to login' do
        expect(response).to redirect_to(login_path)
      end


      it 'sets an error flash' do
        expect(flash_error).to_not be_nil
      end
    end
  end

  # ----------------------------------------
  # DELETE #destroy
  # ----------------------------------------

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, :id => user.id }


    before do
      user
    end


    context 'the user IS logged in' do
      before do
        create_session(user)
      end


      it 'destroys the user' do
        expect { delete_destroy }.to change(User, :count).by(-1)
      end


      it 'sets a success flash' do
        delete_destroy
        expect(flash_success).to_not be_nil
      end


      it 'redirects to the root path' do
        delete_destroy
        expect(response).to redirect_to(root_path)
      end
    end


    context 'the user is NOT logged in' do
      before do
        delete_destroy
      end


      it 'redirects to login' do
        expect(response).to redirect_to(login_path)
      end


      it 'sets an error flash' do
        expect(flash_error).to_not be_nil
      end
    end
  end
end

