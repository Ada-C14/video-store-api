require "test_helper"

describe Customer do

  before do
    @simon = customers(:customer_one)
  end

  describe "validations" do
    it 'id valid when all fields are present' do
      expect(@simon.valid?).must_equal true
    end

    it "fails without a name" do
      @simon.name = nil
      expect(@simon.valid?).must_equal false
    end
  end
end
