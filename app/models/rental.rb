class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  validates :customer_id, :video_id, presence: true

  def checkout_update
    self.update(due_date: Date.today.advance(days: 7).to_s(:db))
  end


end
