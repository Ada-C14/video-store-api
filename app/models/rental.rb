class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  validates due_date, presence: true
end
