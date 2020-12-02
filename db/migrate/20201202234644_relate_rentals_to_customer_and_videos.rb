class RelateRentalsToCustomerAndVideos < ActiveRecord::Migration[6.0]
  def change
    add_reference :rentals, :customer, index: true
    add_reference :rentals, :video, index: true
  end
end
