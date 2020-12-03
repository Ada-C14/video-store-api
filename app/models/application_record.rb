class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # def toggle_up_video_count(customer)
  #   video_count = customer.videos_checked_out_count += 1
  #   customer.save
  #
  #   return video_count
  # end
  #
  # def toggle_down_inventory(video)
  #   inventory = video.available_inventory
  #   video.save
  #
  #   return inventory
  # end
end
