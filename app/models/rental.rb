class Rental < ApplicationRecord
  belongs_to :video
  belongs_to :customer

  def checkout_date

  end


end
