class AddCheckinCheckoutDueToRentals < ActiveRecord::Migration[6.0]
  def change
    add_column :rentals, :checkout_date, :date
    add_column :rentals, :checked_out, :boolean
    add_column :rentals, :checkin_date, :date
  end
end
