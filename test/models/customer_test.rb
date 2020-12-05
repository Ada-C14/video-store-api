require 'test_helper'

describe Customer do
  describe 'validations' do
    it 'validates that all fields are present' do
      customer = customers(:customer_one)

      expect(customer.valid?).must_equal true
    end

    it "fails validation if customer's name is missing" do
      customer = customers(:customer_one)
      customer.name = nil

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :name
      expect(customer.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it 'fails validation if customer names are not unique' do
      customer = Customer.find_by(name: 'Simon Del Rosario')
      customer2 = Customer.create(name: 'Simon Del Rosario', registered_at: 'Thur, 29 Apr 2015 07:54:14 -0700', address: '23424 weeee', city: 'Lynnwood', state: 'WA', postal_code: '98126', phone: '(123)423-4566', videos_checked_out_count: 3)

      expect(customer2.valid?).must_equal false
      expect(customer2.errors.messages).must_include :name
      expect(customer2.errors.messages[:name]).must_equal ['has already been taken']
    end

    it 'fails validation if registered_at is missing' do
      customer = customers(:customer_one)
      customer.registered_at = nil

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :registered_at
      expect(customer.errors.messages[:registered_at]).must_equal ["can't be blank"]
    end

    it 'fails validation if address, city, state, and postal_code is missing' do
      customer = customers(:customer_one)
      customer.address = nil
      customer.city = nil
      customer.state = nil
      customer.postal_code = nil

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :address
      expect(customer.errors.messages).must_include :city
      expect(customer.errors.messages).must_include :state
      expect(customer.errors.messages).must_include :postal_code

      expect(customer.errors.messages[:address]).must_equal ["can't be blank"]
      expect(customer.errors.messages[:city]).must_equal ["can't be blank"]
      expect(customer.errors.messages[:state]).must_equal ["can't be blank"]
      expect(customer.errors.messages[:postal_code]).must_equal ["can't be blank"]
    end

    it "fails validation if customer's phone number is missing" do
      customer = customers(:customer_one)
      customer.phone = nil

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :phone
      expect(customer.errors.messages[:phone]).must_equal ["can't be blank"]
    end

    it 'fails validation if phone number is not unique' do
      customer = Customer.find_by(phone: '(469) 734-9111')
      customer2 = Customer.create(name: 'Simon Del Rosario', registered_at: 'Thur, 29 Apr 2015 07:54:14 -0700', address: '23424 weeee', city: 'Lynnwood', state: 'WA', postal_code: '98126', phone: '(469) 734-9111', videos_checked_out_count: 3)

      expect(customer2.valid?).must_equal false
      expect(customer2.errors.messages).must_include :phone
      expect(customer2.errors.messages[:phone]).must_equal ['has already been taken']
    end

    it 'must have a video_check_out_counter greater than or equal to 0' do
      customer = customers(:customer_one)
      customer.videos_checked_out_count = -1

      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :videos_checked_out_count
      expect(customer.errors.messages[:videos_checked_out_count]).must_equal ['must be greater than or equal to 0']
    end
  end

  describe 'custom methods' do

    let (:customer) {
      Customer.first
    }

    describe 'check_in' do
      it 'will decrease videos_checked_out_count by 1' do

        expect{ customer.check_in }.must_change 'customer.videos_checked_out_count', -1
      end
    end

    describe 'check_out' do
      it 'will increase videos_checked_out_count by 1' do
        expect{ customer.check_out }.must_change 'customer.videos_checked_out_count', 1
      end
    end
  end
end
