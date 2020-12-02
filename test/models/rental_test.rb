require "test_helper"

describe Rental do
  it "can be instantiated" do
    rentals.each do |rental|
      expect(rental.valid?).must_equal true
      expect(rental.errors).must_be_empty
    end
  end
  it "will have the required fields" do
    Rental.column_names.each do |field|
      expect(rentals(:rental0)).must_respond_to field
    end
  end

  describe "relations" do
    it "has a customer" do
      expect(rentals(:rental0)).must_respond_to :customer
      expect(rentals(:rental0).customer).must_be_kind_of Customer
    end

    it "has a video" do
      expect(rentals(:rental0)).must_respond_to :video
      expect(rentals(:rental0).video).must_be_kind_of Video
    end
  end

  describe "validations" do
    it "has a valid due date field" do
      
    end
  end
end
