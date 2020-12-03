class AddRentalsToCustomersAndVideos < ActiveRecord::Migration[6.0]
  def change
    add_reference :rentals, :customer, null: false, foreign_key: true
    add_reference :rentals, :video, null: false, foreign_key: true
  end
end
