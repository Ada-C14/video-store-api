class Video < ApplicationRecord
  validates :title, :overview, :release_date, :total_inventory, :available_inventory, presence: true
end
