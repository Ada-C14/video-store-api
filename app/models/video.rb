class Video < ApplicationRecord
  has_many :rentals

  validates :title, presence: true
  # TODO: do we want to validate uniqueness of movie titles?
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :total_inventory, presence: true
  validates :available_inventory, presence: true

end
