require "test_helper"

describe Customer do
  let (:wonder_woman) { videos(:wonder_woman) }
  let (:black_widow) { videos(:black_widow) }
  let (:customer_one) { customers(:customer_one) }
  let (:customer_two) { customers(:customer_two) }
  let (:rental_one) { rentals(:rental_one) }
  let (:rental_two) { rentals(:rental_two) }
  let (:customer_three) { customers(:customer_three) }

  describe "RELATION" do
    # describe "has many rentals" do
    #   it "can get correct rentals count for valid customer" do
    #     expect(customer_one.rentals.count).must_equal 1
    #   end
    #
    #   it "if no rentals, return 0 rental count" do
    #     expect(customer_three.rentals.count).must_equal 0
    #   end
    # end
    #
    # describe "has many videos" do
    #   skip
    #   it "has many videos, thru rentals" do
    #     expect(customer_two.videos.count).must_equal 1
    #   end
    #
    #   it "responds with an empty array if no movies have been rented" do
    #     expect(customer_three.videos.count).must_equal 0
    #   end
    # end
  end

  describe "VALIDATION" do

    it "has a name" do
      # Assert
      expect(customer_one.name).must_equal "Simon Del Rosario"
    end

    it "will fail if it doesnt have a name" do
      bad_user = Customer.new(name: nil, address: "801 Dexter Ave", registered_at: Date.parse("Wed, 29 Apr 2015"), city: "Seattle", state: "WA", postal_code: "98116")

      expect(bad_user.valid?).must_equal false
    end

    it "has registered_at" do
      # Assert
      expect(customer_one.registered_at).wont_be_nil
    end

    it "will fail if it isnt registered" do
      bad_user = Customer.new(name: "Cloudy", address: "801 Dexter Ave", registered_at: nil, city: "Seattle", state: "WA", postal_code: "98116")

      expect(bad_user.valid?).must_equal false
    end

    it "has an address" do
      expect(customer_one.address).wont_be_nil
    end

    it "will fail if an address is not provided" do
      bad_user = Customer.new(name: "Cloudy", address: nil, registered_at: Date.parse("Wed, 29 Apr 2015"), city: "Seattle", state: "WA", postal_code: "98116")

      expect(bad_user.valid?).must_equal false
    end

    it "has a city" do
      expect(customer_one.city).wont_be_nil
    end

    it "will fail if a city is not provided" do
      bad_user = Customer.new(name: "Cloudy", address: "801 Dexter Ave", registered_at: Date.parse("Wed, 29 Apr 2015"), city: nil, state: "WA", postal_code: "98116")

      expect(bad_user.valid?).must_equal false
    end

    it "has a state" do
      expect(customer_one.state).wont_be_nil
    end

    it "will fail if a state is not provided" do
      bad_user = Customer.new(name: "Cloudy", address: "801 Dexter Ave", registered_at: Date.parse("Wed, 29 Apr 2015"), city: "Seattle", state: nil, postal_code: "98116")

      expect(bad_user.valid?).must_equal false
    end

    it "has a postal code" do
      expect(customer_one.postal_code).wont_be_nil
    end

    it "will fail if a zipcode is not provided" do
      bad_user = Customer.new(name: "Cloudy", address: "801 Dexter Ave", registered_at: Date.parse("Wed, 29 Apr 2015"), city: "Seattle", state: "WA", postal_code: nil)

      expect(bad_user.valid?).must_equal false
    end

    it "has a phone number" do
      expect(customer_one.phone).wont_be_nil
    end

    it "will fail if a phone number is not listed" do
      bad_user = Customer.new(name: "Cloudy", address: "801 Dexter Ave", registered_at: Date.parse("Wed, 29 Apr 2015"), city: nil, state: "WA", postal_code: "98116")

      expect(bad_user.valid?).must_equal false
    end
  end

  describe "CUSTOM METHODS" do
    ### NONE SO FAR
    it "nominal" do
    end

    it "edge" do
    end
  end
end
