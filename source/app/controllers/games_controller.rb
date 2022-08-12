# frozen_string_literal: true

class GamesController < ApplicationController
  include OnePageApplication
  include LoggedUser

  protect_from_forgery except: %i[create update]

  resource_for Game,
               except: :delete,
               paginated: true,
               per_page: Settings.pagination
end

