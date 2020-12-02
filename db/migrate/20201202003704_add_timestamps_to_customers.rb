class AddTimestampsToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :customers
  end
end
