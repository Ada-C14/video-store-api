class Rental < ApplicationRecord
  belongs_to :customer, counter_cache: :videos_checked_out_count
  belongs_to :video
end

# with counter_cache customer.rentals.size will perform the count