class CreateRentals < ActiveRecord::Migration[6.0]
  def change
    create_table :rentals do |t|
      t.integer :customer_id
      t.integer :video_id
      t.datetime :checkout_date
      t.datetime :due_date
      t.string :status

      t.timestamps
    end
  end
end
