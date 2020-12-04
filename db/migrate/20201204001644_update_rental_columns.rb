class UpdateRentalColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :rentals, :videos_checked_out_count
    remove_column :rentals, :available_inventory
    add_column :rentals, :checkout_date, :date
  end
end
