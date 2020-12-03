class AddReturnedAndCheckOutDateToRentals < ActiveRecord::Migration[6.0]
  def change
    add_column :rentals, :check_out_date, :datetime
    add_column :rentals, :returned, :boolean
  end
end
