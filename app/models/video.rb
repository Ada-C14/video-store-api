class Video < ApplicationRecord
    has_many :rentals
    has_many :customers

    validates :title, presence: true
    
end
