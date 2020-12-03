class AddPhoneColumnToCustomer < ActiveRecord::Migration[6.0]
  def change
    remove_column :customers,:phone_number
    add_column :customers,:phone,:string
  end
end
