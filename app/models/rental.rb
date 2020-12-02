class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  validates :customer, :video, :due_date, presence: true
  # validates :return_date, presence: true, on: :update


end
