class AddCheckInToRentals < ActiveRecord::Migration[6.0]
  def change
    add_column :rentals, :check_in, :date
  end
end
