# frozen_string_literal: true

require 'spec_helper'

describe GamesController, :logged, type: :controller do
  let(:user) { logged_user }

  let(:expected_json) do
    Game::Decorator.new(expected_object).to_json
  end

  describe 'GET new' do
    render_views

    context 'when requesting html and ajax is true', :cached do
      before do
        get :new, params: { format: :html, ajax: true }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('games/new') }
    end

    context 'when requesting html and ajax is false' do
      before do
        get :new
      end

      it do
        expect(response).to redirect_to('#/games/new')
      end
    end

    context 'when requesting json', :not_cached do
      let(:expected_object) { Game.new }

      before do
        get :new, params: { format: :json }
      end

      it { expect(response).to be_successful }

      it 'returns games serialized' do
        expect(response.body).to eq(expected_json)
      end
    end
  end

  describe 'GET index' do
    let(:games_count) { 1 }
    let(:parameters) { {} }

    render_views

    before do
      create_list(:game, games_count, user: user)
      create_list(:game, games_count)
    end

    context 'when requesting json', :not_cached do
      let(:expected_object) { user.games }

      before do
        get :index, params: parameters.merge(format: :json)
      end

      it { expect(response).to be_successful }

      it 'returns games serialized' do
        expect(response.body).to eq(expected_json)
      end

      it 'adds page header' do
        expect(response.headers['page']).to eq(1)
      end

      it 'adds pages header' do
        expect(response.headers['pages']).to eq(1)
      end

      it 'adds per_page header' do
        expect(response.headers['per_page']).to eq(Settings.pagination)
      end

      context 'when there are too many games' do
        let(:games_count) { 2 * Settings.pagination + 1 }
        let(:expected_object) { user.games.limit(Settings.pagination) }

        it { expect(response).to be_successful }

        it 'returns games serialized' do
          expect(response.body).to eq(expected_json)
        end

        it 'adds page header' do
          expect(response.headers['page']).to eq(1)
        end

        it 'adds pages header' do
          expect(response.headers['pages']).to eq(3)
        end

        it 'adds per_page header' do
          expect(response.headers['per_page']).to eq(Settings.pagination)
        end
      end

      context 'when requesting last page' do
        let(:games_count) { 2 * Settings.pagination + 1 }
        let(:expected_object) { user.games.offset(2 * Settings.pagination) }
        let(:parameters)      { { page: 3 } }

        it { expect(response).to be_successful }

        it 'returns games serialized' do
          expect(response.body).to eq(expected_json)
        end

        it 'adds page header' do
          expect(response.headers['page']).to eq(3)
        end

        it 'adds pages header' do
          expect(response.headers['pages']).to eq(3)
        end

        it 'adds per_page header' do
          expect(response.headers['per_page']).to eq(Settings.pagination)
        end
      end
    end

    context 'when requesting html and ajax is true', :cached do
      before do
        get :index, params: { format: :html, ajax: true }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('games/index') }
    end

    context 'when requesting html and ajax is false' do
      before do
        get :index
      end

      it { expect(response).to redirect_to('#/games') }
    end
  end

  describe 'POST create' do
    context 'when requesting json format' do
      let(:game) { Game.last }

      let(:parameters) do
        { format: :json, game: payload }
      end

      let(:payload) do
        {
          name: 'my game'
        }
      end

      let(:expected_object) { game }

      it do
        post :create, params: parameters

        expect(response).to be_successful
      end

      it do
        expect { post :create, params: parameters }
          .to change(Game, :count)
          .by(1)
      end

      context 'when the request is completed' do
        before { post :create, params: parameters }

        let(:game) { Game.last }

        let(:game_attributes) do
          game.attributes.reject do |key, _|
            %w[id user_id created_at updated_at].include? key
          end
        end

        let(:expected_game_attributes) do
          payload.stringify_keys
        end

        it 'returns created game' do
          expect(response.body).to eq(expected_json)
        end

        it 'creates a correct game' do
          expect(game_attributes)
            .to eq(expected_game_attributes)
        end
      end
    end
  end

  describe 'GET show' do
    render_views

    let(:game)    { create(:game, user: user) }
    let(:game_id) { game.id }

    context 'when requesting html and ajax is true', :cached do
      before do
        get :show, params: { format: :html, ajax: true, id: game_id }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('games/show') }
    end

    context 'when requesting html and ajax is false' do
      before do
        get :show, params: { id: game_id }
      end

      it do
        expect(response).to redirect_to("#/games/#{game_id}")
      end
    end

    context 'when requesting json', :not_cached do
      let(:expected_object) { game }

      before do
        get :show, params: { id: game_id, format: :json }
      end

      it { expect(response).to be_successful }

      it 'returns games serialized' do
        expect(response.body).to eq(expected_json)
      end
    end
  end

  describe 'GET edit' do
    render_views

    let(:game)    { create(:game, user: user) }
    let(:game_id) { game.id }

    context 'when requesting html', :cached do
      before do
        get :edit, params: { format: :html, id: game_id }
      end

      it { expect(response).to redirect_to("#/games/#{game_id}/edit.html") }
    end

    context 'when requesting html and ajax is true', :cached do
      before do
        get :edit, params: { format: :html, ajax: true, id: game_id }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('games/edit') }
    end
  end

  describe 'PATCH update' do
    context 'when requesting json format' do
      let(:game)    { create(:game, user: user) }
      let(:game_id) { game.id }
      let(:expected_json) do
        Game::Decorator.new(expected_object.reload).to_json
      end

      let(:parameters) do
        { format: :json, id: game_id, game: payload }
      end

      let(:payload) do
        {
          name: 'new name'
        }
      end

      let(:expected_object) { game }

      it 'updates the game' do
        expect { patch :update, params: parameters }
          .to(change { game.reload.name })
      end

      it 'returns game with errors' do
        patch :update, params: parameters

        expect(response.body).to eq(expected_json)
      end
    end
  end
end
