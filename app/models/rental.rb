class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video
end

# with counter_cache customer.rentals.size will perform the count counter_cache: :videos_checked_out_count