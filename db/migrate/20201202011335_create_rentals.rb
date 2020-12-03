class CreateRentals < ActiveRecord::Migration[6.0]
  def change
    create_table :rentals do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :video, null: false, foreign_key: true
      t.datetime :due_date

      t.timestamps
    end
  end
end
