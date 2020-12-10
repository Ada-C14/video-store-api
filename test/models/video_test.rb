require "test_helper"

describe Video do
  describe "instantiation" do
    it "can be instantiated" do
      #Assert
      video = videos(:black_widow)
      expect(video.valid?).must_equal true
    end

    it "will have the requered fields" do
      # Arrange
      video = videos(:black_widow)
      video.save

      [:title].each do |field|

        # Assert
        expect(video).must_respond_to field
      end
    end
  end

  describe 'relations' do
    it 'can have many rentals' do

      video = videos(:black_widow)

      expect(video).must_respond_to :rentals
      video.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
    end

    it 'can have no rentals' do
      video = videos(:holidate)

      expect(video).must_respond_to :rentals
      video.rentals.each do |rental|
        expect(rental).must_be_kind_of Rental
      end
      expect(video.rentals.count).must_equal 0
    end
  end

  describe "validations" do
    it "video must have a title" do
      # Arrange
      video = Video.find_by(title: 'Holidate')
      video.title = nil
      # Assert
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :title
      expect(video.errors.messages[:title]).must_equal ["can't be blank"]
    end

    it "video title must be unique" do
      # Arrange
      video = Video.new
      video.title = 'Holidate'
      # Assert
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :title
      expect(video.errors.messages[:title]).must_equal ["has already been taken"]
    end
  end
end
