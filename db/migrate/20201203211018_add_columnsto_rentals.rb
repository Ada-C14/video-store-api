class AddColumnstoRentals < ActiveRecord::Migration[6.0]
  def change
    add_column :rentals, :videos_checked_out_count, :integer
    add_column :rentals, :available_inventory, :integer
  end
end
