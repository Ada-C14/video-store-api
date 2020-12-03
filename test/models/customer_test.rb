require "test_helper"

describe Customer do

  before do
    @simon = customers(:customer_one)
  end

  describe "validations" do
    it "requires a name" do
      @simon.name = nil
      expect(@simon.valid?).must_equal false
    end

    it "fails with an invalid name" do
      skip
    end
  end
end
