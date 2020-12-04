class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.datetime :registered_at
      t.string :address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :phone
      t.integer :videos_checked_out_count, default: 0

      t.timestamps
    end
  end
end
