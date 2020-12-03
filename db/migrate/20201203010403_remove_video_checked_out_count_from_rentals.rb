class RemoveVideoCheckedOutCountFromRentals < ActiveRecord::Migration[6.0]
  def change
    remove_column :rentals, :video_checked_out_count
  end
end
