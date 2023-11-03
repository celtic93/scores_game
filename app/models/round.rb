# frozen_string_literal: true

class Round < ApplicationRecord
  has_many :matches, dependent: :destroy
  has_many :users, -> { distinct }, through: :matches

  validates :chat_id, presence: true

  scope :active, -> { where(active: true) }

  def matches_started?
    matches.pluck(:date_time).any? { |date_time| Time.zone.now > date_time }
  end
end
