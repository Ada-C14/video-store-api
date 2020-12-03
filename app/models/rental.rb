class Rental < ApplicationRecord
  belongs_to :customer
  belongs_to :video

  validates_date :due_date, on_or_after: lambda { Date.current }

end
