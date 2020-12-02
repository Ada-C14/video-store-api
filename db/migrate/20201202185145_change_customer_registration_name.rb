class ChangeCustomerRegistrationName < ActiveRecord::Migration[6.0]
  def change
    remove_column :customers, :registration_date
    add_column :customers, :registered_at, :datetime
  end
end
