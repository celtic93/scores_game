# frozen_string_literal: true

class User < ApplicationRecord
  has_many :predictions, dependent: :destroy
end
