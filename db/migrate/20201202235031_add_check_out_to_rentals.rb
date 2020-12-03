class AddCheckOutToRentals < ActiveRecord::Migration[6.0]
  def change
    add_column :rentals, :check_out, :date
  end
end
