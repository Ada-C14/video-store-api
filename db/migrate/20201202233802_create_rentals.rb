class CreateRentals < ActiveRecord::Migration[6.0]
  def change
    create_table :rentals do |t|
      t.date :due_date
      t.integer :videos_checked_out_count
      t.integer :available_inventory

      t.timestamps
    end
  end
end
