class AddCheckedInCheckedOut < ActiveRecord::Migration[6.0]
  def change
    add_column :rentals, :checked_out, :datetime
    add_column :rentals, :checked_in, :datetime
  end
end
