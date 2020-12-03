class Video < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  def format_date(date)
    date.strftime("%B")
  end

end
