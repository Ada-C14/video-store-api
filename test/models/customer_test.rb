require "test_helper"

describe Customer do

  describe "relations" do

    it "has rentals" do
      customer_1 = customers(:customer_1)
      expect(customer_1).must_respond_to :rentals
      customer_1.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
    end



  end

end
