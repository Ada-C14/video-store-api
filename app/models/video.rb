class Video < ApplicationRecord
  has_many :rentals
  has_many :customers, through: :rentals

  validate :valid_date

  validates_presence_of :title, :overview, :release_date, :total_inventory, :available_inventory
  validates :title, uniqueness: true
  validates :total_inventory, numericality: {only_integer: true,
                                             greater_than: 0}
  validates :available_inventory, numericality: {only_integer: true,
                                                 greater_than_or_equal_to: 0,
                                                 less_than_or_equal_to: :total_inventory}

  def valid_date
    begin
      unless release_date.is_a?(Date)
        Date.parse(release_date)
      end
    rescue
      errors.add(:release_date, "must be valid date")
    end
  end
end
