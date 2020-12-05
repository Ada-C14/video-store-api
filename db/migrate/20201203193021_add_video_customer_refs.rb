class AddVideoCustomerRefs < ActiveRecord::Migration[6.0]
  def change
    add_reference :rentals, :video, index: true
    add_reference :rentals, :customer, index: true
  end
end
