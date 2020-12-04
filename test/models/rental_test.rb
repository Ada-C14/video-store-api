require "test_helper"

describe Rental do
  let(:rental) {
    Rental.new(customer: customers(:customer_one),
               video: videos(:black_widow))
  }

  describe "relations" do
    it "belongs to customer" do
      rental.must_respond_to :customer
      (rental.customer).must_be_kind_of Customer
    end

    it "belongs to video" do
      rental.must_respond_to :video
      (rental.video).must_be_kind_of Video
    end
  end

  describe "validations" do
    it 'is valid when required fields are present' do
      expect(rental.valid?).must_equal true
    end

    it 'must have a valid customer ID' do
      rental.customer_id = nil

      expect(rental.valid?).must_equal false
      expect(rental.errors.messages).must_include :customer_id
      expect(rental.errors.messages[:customer_id]).must_equal ["can't be blank"]
    end

    it 'must have a valid video ID' do
      rental.video_id = nil

      expect(rental.valid?).must_equal false
      expect(rental.errors.messages).must_include :video_id
      expect(rental.errors.messages[:video_id]).must_equal ["can't be blank"]
    end
  end

  describe "custom methods" do
    describe "check_out_video" do
      it "saves a valid rental to db" do
        rental.check_out_video

        expect(rental.save).must_equal true
      end

      it "will decrease the available_inventory of video by 1" do
        before_inventory = rental.video.available_inventory
        rental.check_out_video

        expect(rental.video.available_inventory).must_equal before_inventory - 1
      end

      it "will increase videos_checked_out_count for customer by 1" do
        before_count = rental.customer.videos_checked_out_count
        rental.check_out_video

        expect(rental.customer.videos_checked_out_count).must_equal before_count + 1
      end

      it "will not save rental to db when available_inventory is equal to 0" do
        rental.video.available_inventory = 0

        expect(rental.check_out_video).must_equal false
      end
    end

    describe "check_in_video" do
      it "saves a valid rental to db" do
        rental.check_in_video

        expect(rental.save).must_equal true
      end

      it "will increase the available_inventory of video by 1" do
        before_inventory = rental.video.available_inventory
        rental.check_in_video

        expect(rental.video.available_inventory).must_equal before_inventory + 1
      end

      it "will decrease videos_checked_out_count for customer by 1" do
        before_count = rental.customer.videos_checked_out_count
        rental.check_in_video

        expect(rental.customer.videos_checked_out_count).must_equal before_count - 1
      end

      it "will not save rental to db when videos_checked_out_count is equal to 0" do
        rental.customer.videos_checked_out_count = 0

        expect(rental.check_in_video).must_equal false
      end
    end
  end
end

