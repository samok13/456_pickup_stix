require 'rails_helper'


describe PlaylistSelectionsController do
  let(:user) { create(:user) }
  let(:artist) { create(:artist) }
  let(:song) { create(:song, :artist => artist) }
  let(:playlist) { create(:playlist, :user => user) }
  let(:playlist_selection) { create(:playlist_selection, :song => song, :playlist => playlist) }

  before do
    set_http_referer
  end

  # ----------------------------------------
  # POST #create
  # ----------------------------------------

  describe 'POST #create' do
    let(:post_create_valid) do
      post :create,
        :playlist_selection => {
          :song_id => song.id,
          :playlist_id => playlist.id
        }
    end

    let(:post_create_invalid) do
      post :create,
        :playlist_selection => {
          :song_id => 0,
          :playlist_id => 0
        }
    end


    context 'the user is NOT logged in' do
      it 'does not create the playlist selection' do
        expect { post_create_valid }.to change(PlaylistSelection, :count).by(0)
      end

      it 'redirects to login' do
        post_create_valid
        expect(response).to redirect_to(login_path)
      end
    end


    context 'the user IS logged in' do
      context 'the data is valid' do
        before do
          create_session(user)
        end


        it 'creates the playlist selection' do
          expect { post_create_valid }.to change(PlaylistSelection, :count).by(1)
        end


        it 'sets a success flash message' do
          post_create_valid
          expect(flash_success).to_not be_nil
        end


        it 'redirects back' do
          post_create_valid
          expect(response).to redirect_to(:back)
        end
      end


      context 'the data is invalid' do
        before do
          create_session(user)
        end

        it 'does not create the playlist selection' do
          expect { post_create_invalid }.to change(PlaylistSelection, :count).by(0)
        end


        it 'sets an error flash' do
          post_create_invalid
          expect(flash_error).to_not be_nil
        end


        it 'redirects to back' do
          post_create_invalid
          expect(response).to redirect_to(:back)
        end
      end
    end
  end

  # ----------------------------------------
  # DELETE #destroy
  # ----------------------------------------

  describe 'DELETE #destroy' do
    let(:delete_destroy_valid) { delete :destroy, :id => playlist_selection.id }
    let(:delete_destroy_invalid) { delete :destroy, :id => 0 }


    before do
      playlist_selection
    end


    context 'the user IS logged in' do
      before do
        create_session(user)
      end

      context 'when valid' do
        it 'destroys the playlist selection' do
          expect { delete_destroy_valid }.to change(PlaylistSelection, :count).by(-1)
        end


        it 'sets a success flash' do
          delete_destroy_valid
          expect(flash_success).to_not be_nil
        end
      end


      context 'when invalid' do
        it 'does NOT destroy the playlist selection' do
          expect { delete_destroy_invalid }.to change(PlaylistSelection, :count).by(0)
        end


        it 'sets a error flash' do
          delete_destroy_invalid
          expect(flash_error).to_not be_nil
        end
      end
    end


    context 'the user is NOT logged in' do
      it 'does NOT destroy the playlist selection' do
        expect { delete_destroy_valid }.to change(PlaylistSelection, :count).by(0)
      end


      it 'redirects to login' do
        delete_destroy_valid
        expect(response).to redirect_to(login_path)
      end


      it 'sets an error flash' do
        delete_destroy_valid
        expect(flash_error).to_not be_nil
      end
    end
  end
end

