class Video < ApplicationRecord
    has_many :rentals
    has_many :customers

    validates :title, presence: true
    validates :overview, presence: true
    validates :release_date, presence: true
    validates :total_inventory, presence: true
    validates :available_inventory, presence: true

end
