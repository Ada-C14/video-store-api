class CustomerRegistratedAtToDateTime < ActiveRecord::Migration[6.0]
  def change
    remove_column :customers, :registered_at
    add_column :customers, :registered_at, :datetime
  end
end
