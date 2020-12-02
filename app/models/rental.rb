class Rental < ApplicationRecord
  validates :video_id, presence: true
  validates :customer_id, presence: true
  validates :due_date, presence: true

  belongs_to :video
  belongs_to :customer

end
