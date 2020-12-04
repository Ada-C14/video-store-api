require "test_helper"

describe Video do
  describe "validations" do
    let (:black_widow) {videos(:black_widow)}
    it "can be created" do
      expect(black_widow.valid?).must_equal true
    end

    it "requires name address city state postal_code phone" do
      required_fields = [:title, :available_inventory, :total_inventory, :overview, :release_date]

      required_fields.each do |field|
        black_widow[field] = nil

        expect(black_widow.valid?).must_equal false

        black_widow.reload
      end
    end
  end
end
