require "test_helper"

describe Rental do
  describe "Relations" do
    it "has a video" do
      rental = rentals(:rental1)
      expect(rental).must_respond_to :video
      expect(rental.video).must_be_kind_of Video
    end
    it "has a customer" do
      rental = rentals(:rental1)
      expect(rental).must_respond_to :customer
      expect(rental.customer).must_be_kind_of Customer
    end
  end

  describe "Validations" do
    it "is a valid rental when all fields present" do
      expect(rentals(:rental1).valid?).must_equal true
    end
    it "is an invalid rental when missing a video" do
      rental = rentals(:rental1)
      rental.video = nil
      expect(rentals(:rental1).valid?).must_equal false
    end
    it "is an invalid rental when missing a customer" do
      rental = rentals(:rental1)
      rental.customer = nil
      expect(rentals(:rental1).valid?).must_equal false
    end
  end
end
