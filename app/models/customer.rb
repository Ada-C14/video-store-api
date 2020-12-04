class Customer < ApplicationRecord
  has_many :videos

  default_scope { order(id: :asc) }

  def checkout_update
    self.update(videos_checked_out_count: self.videos_checked_out_count + 1)
  end

  def checkin_update
    self.update(videos_checked_out_count: self.videos_checked_out_count - 1)
  end
end
