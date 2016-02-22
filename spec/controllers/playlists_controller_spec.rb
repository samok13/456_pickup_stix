require 'rails_helper'


describe PlaylistsController do
  let(:user) { create(:user) }
  let(:playlist) { create(:playlist, :user => user) }


  before do
    set_http_referer
  end


  # ----------------------------------------
  # GET #show
  # ----------------------------------------

  describe 'GET #show' do
    let(:get_show) { get :show, :id => playlist.id }


    before do
      playlist
      get_show
    end


    it 'renders the show template' do
      expect(response).to render_template(:show)
    end


    it 'sets an instance variable to the playlist' do
      expect(assigns[:playlist]).to eq(playlist)
    end
  end

  # ----------------------------------------
  # GET #new
  # ----------------------------------------

  describe 'GET #new' do
    context 'the user IS logged in' do
      before do
        create_session(user)
        get :new
      end

      it 'renders the new template' do
        expect(response).to render_template(:new)
      end


      it 'sets an instance variable to a new playlist' do
        expect(assigns[:playlist]).to be_an_instance_of(Playlist)
        expect(assigns[:playlist]).to_not be_persisted
      end
    end


    context 'the user is NOT logged in' do
      before do
        get :new
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
  # GET #edit
  # ----------------------------------------

  describe 'GET #edit' do
    let(:get_edit) { get :edit, :id => playlist.id }


    context 'the user IS logged in' do
      before do
        create_session(user)
        get_edit
      end


      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end


      it 'sets an instance variable to the playlist' do
        expect(assigns[:playlist]).to eq(playlist)
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
        :playlist => {
          :name => 'Foobar'
        }
    end

    let(:post_create_invalid) do
      post :create,
        :playlist => {
          :name => ''
        }
    end


    context 'the user IS logged in' do
      before do
        create_session(user)
      end


      context 'the data is valid' do
        it 'creates the playlist' do
          expect { post_create_valid }.to change(Playlist, :count).by(1)
        end


        it 'redirects to the playlist' do
          post_create_valid
          playlist = Playlist.last
          expect(response).to redirect_to(playlist)
        end


        it 'sets a success flash' do
          post_create_valid
          expect(flash_success).to_not be_nil
        end
      end


      context 'the data is invalid' do
        it 'does NOT create the playlist' do
          expect { post_create_invalid }.to change(Playlist, :count).by(0)
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


    context 'the user is NOT logged in' do
      before do
        post_create_valid
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
  # PUT #update
  # ----------------------------------------

  describe 'PUT #update' do
    let(:put_update_valid) do
      put :update,
        :id => playlist.id,
        :playlist => {
          :name => 'Foobar'
        }
    end

    let(:put_update_invalid) do
      put :update,
        :id => playlist.id,
        :playlist => {
          :name => ''
        }
    end


    before do
      playlist
    end


    context 'the user IS logged in' do
      before do
        create_session(user)
      end

      context 'the data is valid' do
        before do
          put_update_valid
          playlist.reload
        end


        it 'updates the playlist' do
          expect(playlist.name).to eq('Foobar')
        end


        it 'redirects to the playlist' do
          expect(response).to redirect_to(playlist)
        end


        it 'sets a success flash' do
          expect(flash_success).to_not be_nil
        end
      end


      context 'the data is invalid' do
        before do
          put_update_invalid
        end


        it 'does not update the playlist' do
          expect(playlist.name).to_not eq('Foobar')
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
    let(:delete_destroy_valid) { delete :destroy, :id => playlist.id }
    let(:delete_destroy_invalid) { delete :destroy, :id => 0 }


    before do
      playlist
    end


    context 'the user IS logged in' do
      before do
        create_session(user)
      end


      context 'the data is valid' do
        it 'destroys the playlist' do
          expect { delete_destroy_valid }.to change(Playlist, :count).by(-1)
        end


        it 'sets a success flash' do
          delete_destroy_valid
          expect(flash_success).to_not be_nil
        end


        it 'redirects to the user' do
          delete_destroy_valid
          expect(response).to redirect_to(user)
        end
      end


      context 'the data is invalid' do
        it 'does NOT destroy the playlist' do
          expect { delete_destroy_invalid }.to change(Playlist, :count).by(0)
        end

        it 'sets an error flash' do
          delete_destroy_invalid
          expect(flash_error).to_not be_nil
        end


        it 'redirects to the user' do
          delete_destroy_invalid
          expect(response).to redirect_to(:back)
        end
      end
    end


    context 'the user is NOT logged in' do
      before do
        delete_destroy_valid
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




