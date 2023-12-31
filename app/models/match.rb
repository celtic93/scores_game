# frozen_string_literal: true

class Match < ApplicationRecord
  belongs_to :round
  has_many :predictions, dependent: :destroy
  has_many :users, through: :predictions

  scope :ordered_by_id, -> { order(:id) }

  def different_predictions?
    predictions.pluck(:score).uniq.size > 1
  end
end
