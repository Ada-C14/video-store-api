class RemoveVideosCheckedOutCountAndAvailableInventoryFromRentals < ActiveRecord::Migration[6.0]
  def change
    remove_column :rentals, :videos_checked_out_count
    remove_column :rentals, :available_inventory
  end
end
