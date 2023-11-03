# frozen_string_literal: true

class Prediction < ApplicationRecord
  belongs_to :user
  belongs_to :match

  validates :score, presence: true

  scope :for_round, ->(round_id) { joins(:match).where(match: { round_id: round_id }).distinct }
end
