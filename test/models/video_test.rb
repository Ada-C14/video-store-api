require "test_helper"

describe Video do
  let(:video) { videos(:wonder_woman) }

  it "can be instantiated" do
    expect(video.valid?).must_equal true
  end

  describe "validations" do
    it 'is valid when required fields are present' do
      result = video.valid?
      expect(result).must_equal true
    end

    it 'is invalid with available inventory of less than zero' do
      video.available_inventory = -1
      result = video.valid?

      expect(result).must_equal false
    end
    
    it 'is valid with available inventory greater than or equal to zero' do
      video.available_inventory = 0
      result = video.valid?

      expect(result).must_equal true
    end

    it 'is invalid with available inventory that is not an integer' do
      video.available_inventory = "Kaida is awesome!!!"
      result = video.valid?

      expect(result).must_equal false
      expect(video.errors.messages).must_include :available_inventory
      expect(video.errors.messages[:available_inventory]).must_equal ["is not a number"]
    end

    it 'must have an available_inventory' do
      video.available_inventory = nil
      result = video.valid?

      expect(result).must_equal false
      expect(video.errors.messages).must_include :available_inventory
      expect(video.errors.messages[:available_inventory]).must_equal ["can't be blank", "is not a number"]
    end

    it 'must have a video title' do
      video.title = nil
      result = video.valid?

      expect(result).must_equal false
      expect(video.errors.messages).must_include :title
      expect(video.errors.messages[:title]).must_equal ["can't be blank"]

    end

    it 'must have a video overview' do
      video.overview = nil
      result = video.valid?

      expect(result).must_equal false
      expect(video.errors.messages).must_include :overview
      expect(video.errors.messages[:overview]).must_equal ["can't be blank"]

    end

    it 'must have a video total_inventory' do
      video.total_inventory = nil
      result = video.valid?

      expect(result).must_equal false
      expect(video.errors.messages).must_include :total_inventory
      expect(video.errors.messages[:total_inventory]).must_equal ["can't be blank"]
    end

    it 'must have a video release_date' do
      video.release_date = nil
      result = video.valid?
      
      expect(result).must_equal false
      expect(video.errors.messages).must_include :release_date
      expect(video.errors.messages[:release_date]).must_equal ["can't be blank"]
    end
  end

  describe "relations" do
    it "has many rentals" do
      expect(video).must_respond_to :rentals
      video.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
    end

    it "has many customers" do
      expect(video).must_respond_to :customers
      video.customers.each do |customer|
        expect(customer).must_be_kind_of Customer
      end
    end
  end
end
