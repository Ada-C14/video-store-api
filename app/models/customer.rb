class Customer < ApplicationRecord
  # unique name?
  # name must be present?
  # what else do we need to be present?
  # videos_checked_out_count must be positive number
  validates :name, presence: true
  validates :videos_checked_out_count, numericality: { greater_than: 0 }
end
