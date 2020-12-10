require "test_helper"

describe Customer do

  describe "instantiation" do
    it "can be instantiated" do
      #Assert
      customer = customers(:customer_one)
      expect(customer.valid?).must_equal true
    end

    it "will have the requered fields" do
      # Arrange
      customer = customers(:customer_one)
      customer.save

      [:name].each do |field|

        # Assert
        expect(customer).must_respond_to field
      end
    end
  end

  describe 'relations' do
    it "can have many rentals" do
      customer = customers(:customer_one)

      expect(customer).must_respond_to :rentals
      customer.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
    end

    it 'can have no videos' do
      customer = customers(:customer_three)

      expect(customer).must_respond_to :rentals
      customer.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
      expect(customer.rentals.count).must_equal 0
    end
  end

  describe "validations" do
    it "customer must have a name" do
      # Arrange
      customer = Customer.find_by(name: 'Becca')
      customer.name = nil
      # Assert
      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :name
      expect(customer.errors.messages[:name]).must_equal ["can't be blank"]
    end

    it "customer name must be unique" do
      # Arrange
      customer = Customer.new
      customer.name = 'Becca'
      # Assert
      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :name
      expect(customer.errors.messages[:name]).must_equal ["has already been taken"]
    end

    it "customer must have a address" do
      # Arrange
      customer = Customer.find_by(address: '1414 Seasame Street')
      customer.address = nil
      # Assert
      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :address
      expect(customer.errors.messages[:address]).must_equal ["can't be blank"]
    end

    it "customer must have a phone number" do
      # Arrange
      customer = Customer.find_by(phone: '(469) 734-9222')
      customer.phone = nil
      # Assert
      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :phone
      expect(customer.errors.messages[:phone]).must_equal ["can't be blank"]
    end
  end
end
