# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :round
  has_many :predictions, dependent: :destroy
  has_many :users, through: :predictions
end
