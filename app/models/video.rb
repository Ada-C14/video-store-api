class Video < ApplicationRecord
  validates :title, :overview, :release_date, :available_inventory, :total_inventory, presence: true
end
