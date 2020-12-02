class FixVideoPostalCodeDatatype < ActiveRecord::Migration[6.0]
  def change
    remove_column :customers, :postal_code
    add_column :customers, :postal_code, :string
  end
end
