class Rental < ApplicationRecord
  belongs_to :video
  belongs_to :customer

  validates :customer_id, presence: true
  validates :video_id, presence: true
  validates :checkout_date, presence: true
  validates :due_date, presence: true


  def self.checkout()

  end

end
