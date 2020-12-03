class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  validates_presence_of :due_date

  validate :cannot_rent_unreleased, on: :create

  def cannot_rent_unreleased
    if self.video.present? && self.video.release_date.present? && self.video.release_date > Date.today
      errors.add(:due_date, "can't rent unreleased movies")
    end
  end

  def check_out
    if self.customer.present? && self.video.present?
      self.customer.videos_checked_out_count += 1
      self.customer.save

      self.video.available_inventory -= 1
      self.video.save
    end

    self.due_date = DateTime.now + 7.days
  end

  def check_in
    if self.customer.present? && self.video.present?
      self.video.available_inventory += 1
      self.video.save

      self.customer.videos_checked_out_count -= 1
      self.customer.save

      return true
    end

    return false
  end

end
