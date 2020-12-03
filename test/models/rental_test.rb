require "test_helper"

describe Rental do
  describe "validations" do
    before do
      @customer = Customer.new(name: "Customer name", address: "Customer address", registered_at: Date.parse("1 Dec 2020"), city: "test city", state: "test state", postal_code: "11111")
      @video = Video.new(title: "test title", overview: "test overview", release_date: Date.parse("13 Jun 2000"), total_inventory: 6, available_inventory: 5)
      @rental = Rental.new(customer_id: @customer.id, video_id: @video.id, checkout_date: Date.today, due_date: Date.today + 7)
    end

    it "has a customer id" do
      expect(@rental.customer_id).must_equal @customer.id
    end

    it "is invald without a customer id" do
      @rental.customer_id = nil

      expect(@rental.valid?).must_equal false
    end

    it "has a video id" do
      expect(@rental.video_id).must_equal @video.id
    end

    it "is invald without a video id" do
      @rental.video_id = nil

      expect(@rental.valid?).must_equal false
    end
  end

end
