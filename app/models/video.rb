class Video < ApplicationRecord
    has_many :rentals
    has_many :customers
end
