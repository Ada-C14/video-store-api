class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # a method for Customer objects
  def toggle_up_video_count
    self.videos_checked_out_count += 1

    self.save

    return self.videos_checked_out_count
  end

  # a method for Video objects
  def toggle_down_inventory
    self.available_inventory -= 1
    self.save

    return self.available_inventory
  end
end
