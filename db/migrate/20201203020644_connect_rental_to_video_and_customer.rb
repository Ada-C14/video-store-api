class ConnectRentalToVideoAndCustomer < ActiveRecord::Migration[6.0]
  def change
    add_reference :rentals, :video, index: true
    add_reference :rentals, :customer, index: true
    add_column :rentals, :due_date, :date
  end
end
