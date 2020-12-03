class Video < ApplicationRecord
  has_many :rentals
  validates :title, presence: true
  validates :available_inventory, :numericality => { :greater_than_or_equal_to => 0 }

  def checkout
    self.available_inventory -= 1
    self.save
  end

end
