class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  validates :due_date, :available_inventory, :customer_id, :video_id, presence: true
end
