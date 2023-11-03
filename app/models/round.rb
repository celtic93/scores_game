# frozen_string_literal: true

class Round < ApplicationRecord
  has_many :matches, dependent: :destroy

  validates :chat_id, presence: true

  scope :active, -> { where(active: true) }
end
