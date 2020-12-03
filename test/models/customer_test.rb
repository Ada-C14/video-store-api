require "test_helper"

describe Customer do
  let (:valid_customer){ customers(:customer_one) }
  let (:invalid_customer){ Customer.create }

  it "can be instantiated when valid" do
    expect(valid_customer.valid?).must_equal true
    expect(valid_customer).must_be_instance_of Customer
  end

  it "will have the required fields" do
    [:name, :address, :city, :state, :postal_code, :phone, :registered_at, :videos_checked_out_count].each do |field|
      expect(valid_customer.send field ).wont_be_nil
    end

    customer_attributes = [:id, :name, :address, :city, :state, :postal_code, :phone, :registered_at, :videos_checked_out_count]

    customer_attributes.each do |attribute|
      expect(valid_customer).must_respond_to attribute
    end
  end

  it "is invalid without the required fields present" do
    expect(invalid_customer.valid?).must_equal false
    [:name, :address, :city, :state, :postal_code, :phone, :registered_at].each do |field|
      expect(invalid_customer.errors.messages[field]).must_include "can't be blank"
    end
    expect(invalid_customer.errors.messages[:videos_checked_out_count]).must_include "is not a number"
  end

  describe 'relationships' do
    it "can have many rentals" do
      expect(valid_customer).must_respond_to :rentals
      valid_customer.rentals.each { |rental| expect(rental).must_be_instance_of Rental }
    end

    it "can have many videos through rentals" do
      expect(valid_customer.videos.first).must_be_instance_of Video
    end
  end
end
