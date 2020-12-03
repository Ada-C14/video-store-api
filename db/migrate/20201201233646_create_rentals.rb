class CreateRentals < ActiveRecord::Migration[6.0]
  def change
    create_table :rentals do |t|
      t.string :due_date
      t.string :return_date

      t.timestamps
    end
  end
end
