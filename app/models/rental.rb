class Rental < ApplicationRecord
  belongs_to :video
  belongs_to :customer

  def due_date
    return Time.now + 7
  end
end
