class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  validates :customer_id, :video_id, presence: true
end
