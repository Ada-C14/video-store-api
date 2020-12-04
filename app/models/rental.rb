class Rental < ApplicationRecord
  belongs_to :video
  belongs_to :customer

  validates :video_id, presence: true
  validates :customer_id, presence: true
end
