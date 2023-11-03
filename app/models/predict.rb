# frozen_string_literal: true

class Predict < ApplicationRecord
  belongs_to :user
  belongs_to :match
end
