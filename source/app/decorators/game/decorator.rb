# frozen_string_literal: true

class Game < ApplicationRecord
  class Decorator < ::ModelDecorator
    expose :name
  end
end
