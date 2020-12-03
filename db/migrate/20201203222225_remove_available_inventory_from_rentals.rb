class RemoveAvailableInventoryFromRentals < ActiveRecord::Migration[6.0]
  def change
    remove_column :rentals, :available_inventory
  end
end
