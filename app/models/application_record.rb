class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def check_out
    if self.class.name == 'Video'
      self.available_inventory -= 1
    else
      self.videos_checked_out_count += 1
    end
    save
  end

  def check_in
    if self.class.name == 'Video'
      self.available_inventory += 1
    else
      self.videos_checked_out_count -= 1
    end
    save
  end
end
