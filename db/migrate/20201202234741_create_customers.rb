class CreateCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :customers do |t|
      t.string :name
      t.datetime :registered_at
      t.string :address
      t.string :city
      t.string :state
      t.integerphone_number :zipcode

      t.timestamps
    end
  end
end
