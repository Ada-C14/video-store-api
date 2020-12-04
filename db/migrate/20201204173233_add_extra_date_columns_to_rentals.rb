class AddExtraDateColumnsToRentals < ActiveRecord::Migration[6.0]
  def change
    add_column :rentals, :due_date, :datetime
    add_column :rentals, :checked_in_date, :datetime
  end
end
