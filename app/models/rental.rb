class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  validates :customer, :video, :due_date, presence: true
  validates :return_date, absence: true, on: :create
  validate :return_after_renting

  def return_after_renting
    if return_date.present? && created_at.present? && Date.parse(return_date) < created_at
      errors.add(:return_date, "video cannot be returned before being rented")
    end
  end

  def checkout_update
    self.video.available_inventory -= 1
    self.video.save
    self.customer.videos_checked_out_count += 1
    self.customer.save
  end
end
