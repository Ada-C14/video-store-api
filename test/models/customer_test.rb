require "test_helper"

describe Customer do

  before do
    @customer = customers(:customer_one)
  end

  it "can be instiantiated when the fields are present" do
    expect(@customer.valid?).must_equal true
  end

  it "responds to the fields" do
    fields = [:name, :registered_at, :postal_code, :videos_checked_out_count]

    fields.each do |field|
      expect(@customer).must_respond_to field
    end
  end

  describe "validations" do

    it "must have a name" do
      @customer.name = nil
      expect(@customer.valid?).must_equal false
      expect(@customer.errors.messages).must_include :name
      expect(@customer.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "must have a phone" do
      @customer.phone = nil
      expect(@customer.valid?).must_equal false
      expect(@customer.errors.messages).must_include :phone
      expect(@customer.errors.messages[:phone]).must_equal ["can't be blank"]
    end

    it "must have a registered_at" do
      @customer.registered_at = nil
      expect(@customer.valid?).must_equal false
      expect(@customer.errors.messages).must_include :registered_at
      expect(@customer.errors.messages[:registered_at]).must_equal ["can't be blank"]

    end
    
    it "must have videos checked out count greater than 0" do
      @customer.videos_checked_out_count = -5

      expect(@customer.valid?).must_equal false
      expect(@customer.errors.messages).must_include :videos_checked_out_count
      expect(@customer.errors.messages[:videos_checked_out_count]).must_equal ["must be greater than 0"]
    end
    
  end
  
  describe "relations" do 
    
  end

  describe "custom methods" do
    
  end
end
