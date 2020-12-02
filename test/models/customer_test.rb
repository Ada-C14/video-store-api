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


  end
end
