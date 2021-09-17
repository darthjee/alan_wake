# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :user

  validates_presence_of :user
  validates :name,
            presence: true,
            length: { maximum: 50 }
end
