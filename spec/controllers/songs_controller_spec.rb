require 'rails_helper'

describe SongsController do
  let(:user) { create(:user) }
  let(:artist) { create(:artist) }
  let(:song) { create(:song, :artist => artist) }

  before do
    song
  end


  # ----------------------------------------
  # GET #show
  # ----------------------------------------

  describe 'GET #show' do
    let(:get_show) { get :show, :id => song.id }


    it 'renders the show template' do
      get_show
      expect(response).to render_template(:show)
    end


    it 'sets an instance variable to the song' do
      get_show
      expect(assigns[:song]).to eq(song)
    end


    context 'the user is signed in' do
      before do
        create_session(user)
        get_show
      end

      it 'sets an instance variable to a new playlist selection to use in the add to playlist form' do
        expect(assigns[:playlist_selection]).to be_an_instance_of(PlaylistSelection)
        expect(assigns[:playlist_selection]).to_not be_persisted
      end
    end
  end
end

