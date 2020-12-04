require "test_helper"

describe Customer do
  let (:new_customer) {
    Customer.new(name: "New Customer", videos_checked_out_count: 0)
  }

  it "can be instantiated" do
    expect(new_customer.valid?).must_equal true
  end

  it "will have the required fields" do
    new_customer.save
    customer = Customer.first
    [:name, :registered_at, :address, :city, :state, :postal_code, :phone, :videos_checked_out_count].each do |field|
      expect(customer).must_respond_to field
    end
  end

  describe "relations" do
    it "has a list of rentals" do
      becca = customers(:customer_two)
      expect(becca).must_respond_to :rentals
      becca.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
    end

    it "has a list of videos" do
      becca = customers(:customer_two)
      expect(becca).must_respond_to :videos
      becca.videos.each do |video|
        expect(video).must_be_kind_of Video
      end
    end
  end

  describe "validations" do
    before do
      @becca = customers(:customer_two)
    end
    it "is valid when all fields are present" do
      expect(@becca.valid?).must_equal true
    end

    it "is valid when checked out video count is greater than or equal to zero" do
      @becca.videos_checked_out_count = 0

      expect(@becca.valid?).must_equal true
    end

    it "is invalid when checked out video count is less than zero" do
      @becca.videos_checked_out_count = -1

      expect(@becca.valid?).must_equal false
      expect(@becca.errors.messages).must_include :videos_checked_out_count
      expect(@becca.errors.messages[:videos_checked_out_count]).must_equal ["must be greater than or equal to 0"]
    end

    it "is invalid when checked out video count is not an integer" do
      @becca.videos_checked_out_count = 0.5

      expect(@becca.valid?).must_equal false
      expect(@becca.errors.messages).must_include :videos_checked_out_count
      expect(@becca.errors.messages[:videos_checked_out_count]).must_equal ["must be an integer"]
    end

    it "must have checked out video count" do
      @becca.videos_checked_out_count = nil

      expect(@becca.valid?).must_equal false
      expect(@becca.errors.messages).must_include :videos_checked_out_count
      expect(@becca.errors.messages[:videos_checked_out_count]).must_equal ["is not a number"]
    end
  end
end
