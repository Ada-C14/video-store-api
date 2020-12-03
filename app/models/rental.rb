class Rental < ApplicationRecord
  belongs_to :video
  belongs_to :customer

  validates :customer_id, presence: true
  validates :video_id, presence: true

  def due_date
    rental_period = 7
    checkout_date = Date.today

    due_date = checkout_date + rental_period
    return due_date
  end
end
