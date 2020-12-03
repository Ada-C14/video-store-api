require "test_helper"

describe Customer do

  describe "relations" do

    it "has rentals" do
      customer_one = customers(:customer_one)
      expect(customer_one).must_respond_to :rentals
      customer_one.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
    end

    it "has videos through rentals" do
      customer_one = customers(:customer_one)
      expect(customer_one).must_respond_to :videos
      customer_one.videos.each do |video|
        expect(video).must_be_kind_of Video
      end
    end

  end

  describe "validations" do

    before do
      @customer = Customer.new(name: "Name", address: "Address", city: "City", state: "State", postal_code: "12345", phone: "1111111111" )
    end

    it "must have a name" do
      @customer.name = nil
      expect(@customer.valid?).must_equal false
      expect(@customer.error.messages).must_include :name
    end

    it "must have an address" do
      @customer.address = nil
      expect(@customer.valid?).must_equal false
      expect(@customer.error.messages).must_include :address
    end

    it "must have a city" do
      @customer.city = nil
      expect(@customer.valid?).must_equal false
      expect(@customer.error.messages).must_include :city
    end

    it "must have a state" do
      @customer.state = nil
      expect(@customer.valid?).must_equal false
      expect(@customer.error_messages).must_include :state
    end


  end

end
