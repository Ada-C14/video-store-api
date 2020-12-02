class CreateRentals < ActiveRecord::Migration[6.0]
  def change
    create_table :rentals do |t|
      t.bigint :video_id
      t.bigint :customer_id
      t.date :checkout_date
      t.date :due_date
      t.date :return_date

      t.timestamps
    end
  end
end
