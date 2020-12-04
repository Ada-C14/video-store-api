require "test_helper"

describe Video do
  let (:video) {
    Video.new(
        title: "Alf the movie",
        overview: "The most early 90s movie of all time",
        release_date: Date.new(2015-12-12),
        total_inventory: 6,
        available_inventory: 6
    )
  }
  describe "validations" do
    it "is valid with all required fields" do
      expect(video.valid?).must_equal true
    end

    it "requires title, overview, release date, total inventory, and available inventory" do
      required_fields = [:title, :overview, :release_date, :total_inventory, :available_inventory]

      required_fields.each do |field|
        video[field] = nil

        expect(video.valid?).must_equal false
        expect(video.errors.messages).must_include field
      end
    end

    it "requires available inventory to be numeric" do
      video.available_inventory = "five"
      expect(video.valid?).must_equal false

      video.available_inventory = 5
      expect(video.valid?).must_equal true
    end

    it "requires total inventory to be numeric" do
      video.total_inventory = "five"
      expect(video.valid?).must_equal false

      video.total_inventory = 5
      expect(video.valid?).must_equal true

    end
  end

end
