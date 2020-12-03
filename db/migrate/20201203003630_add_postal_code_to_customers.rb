class AddPostalCodeToCustomers < ActiveRecord::Migration[6.0]
  def change
    remove_column :customers,:zipcode
    add_column :customers,:postal_code,:string
  end
end
