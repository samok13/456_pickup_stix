require 'rails_helper'

describe ArtistsController do
  let(:user) { create(:user) }
  let(:artist) { create(:artist) }

  before do
    artist
  end



  # ----------------------------------------
  # GET #index
  # ----------------------------------------

  describe 'GET #index' do
    
    before do
      get :index
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end


    it 'sets an instance variable to all artists' do
      expect(assigns[:artists]).to be_kind_of(ActiveRecord::Relation)
    end
  end


  # ----------------------------------------
  # GET #show
  # ----------------------------------------

  describe 'GET #show' do
    let(:get_show) { get :show, :id => artist.id }

    it 'renders the show template' do
      get_show
      expect(response).to render_template(:show)
    end


    it 'sets an instance variable to the artist' do
      get_show
      expect(assigns[:artist]).to eq(artist)
    end


    context 'the user is signed in' do
      before do
        create_session(user)
        get_show
      end


      it 'sets an instance variable to a new playlist_selection to use in all of the add to playlist forms' do
        expect(assigns[:playlist_selection]).to be_an_instance_of(PlaylistSelection)
        expect(assigns[:playlist_selection]).to_not be_persisted
      end
    end
  end
end

