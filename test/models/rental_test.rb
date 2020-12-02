require "test_helper"

describe Rental do
  describe 'validations' do
    before do
      @rental_info = {
          customer: customers(:customer_one),
          video: videos(:wonder_woman),
          due_date: (Date.today + 7).to_s
      }
    end
    it 'is valid with the required fields' do
      rental = Rental.new(@rental_info)

      expect(rental.valid?).must_equal true
    end

    it 'is invalid without a valid customer' do
      @rental_info["customer"] = nil

      rental = Rental.new(@rental_info)

      expect(rental.valid?).must_equal false
      expect(rental.errors.messages[:customer]).must_equal ["must exist", "can't be blank"]
    end

    it 'is invalid without a valid video' do
      @rental_info["video"] = nil
      rental = Rental.new(@rental_info)

      expect(rental.valid?).must_equal false
      expect(rental.errors.messages[:video]).must_equal ["must exist", "can't be blank"]
    end

    it 'is invalid without a due date' do
      @rental_info["due_date"] = nil
      rental = Rental.new(@rental_info)

      expect(rental.valid?).must_equal false
      expect(rental.errors.messages[:due_date]).must_equal ["can't be blank"]
    end
  end
end
