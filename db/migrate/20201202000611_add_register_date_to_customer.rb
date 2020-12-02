class AddRegisterDateToCustomer < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :registered_at, :datetime
  end
end
