class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video


  def calculate_due_date(checkout_date, days_due)
    date = checkout_date + (60 * 60 * 24 * days_due)
    return date.strftime('%Y-%m-%d')
  end
end
