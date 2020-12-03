class ChangeVideoColumnName < ActiveRecord::Migration[6.0]
  def change
    rename_column :videos, :avaialable_inventory, :available_inventory
  end
end
