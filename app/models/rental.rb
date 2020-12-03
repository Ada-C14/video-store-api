class Rental < ApplicationRecord
  belongs_to :video
  belongs_to :customer

  validates :video_id, presence: true
  validates :customer_id, presence: true

  def due
    self.due_date = Date.current + 7
    self.save
    return self.due_date
  end
end

