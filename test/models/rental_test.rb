require "test_helper"

describe Rental do
  describe 'validations' do
    it 'is valid when all fields are present' do
      # Arrange
      rental1 = Rental.new(customer_id: customers(:customer_one).id, video_id: videos(:wonder_woman).id)
      
      # Act
      result = rental1.valid?

      # Assert
      expect(result).must_equal true
    end

    it 'is invalid without customer_id' do
      # Arrange
      rental1 = Rental.new(customer_id: nil, video_id: videos(:wonder_woman).id)
      
      # Act
      result = rental1.valid?

      # Assert
      expect(result).must_equal false
      expect(rental1.errors.messages).must_include :customer_id
      expect(rental1.errors.messages[:customer_id].include?("can't be blank")).must_equal true
    end

    it 'is invalid without video_id' do
      # Arrange
      rental1 = Rental.new(customer_id: customers(:customer_one).id, video_id: nil)
      
      # Act
      result = rental1.valid?

      # Assert
      expect(result).must_equal false
      expect(rental1.errors.messages).must_include :video_id
      expect(rental1.errors.messages[:video_id].include?("can't be blank")).must_equal true
    end
  end

  describe 'custom methods' do
    describe "checkout_update" do
      it 'sets the due date 7 days after the rental date' do
        # Arrange
        rental1 = Rental.new(customer_id: customers(:customer_one).id, video_id: videos(:wonder_woman).id)

        # Act
        rental1.checkout_update

        # Assert
        expect(rental1.due_date - Date.today).must_equal 7
      end
    end
  end
end
