require "test_helper"

describe Rental do

  describe "validations" do
    it "has a due date" do
      video = Video.first
      video.due_date = nil
      video.save

      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :due_date
      expect(video.errors.messages[:due_date]).must_equal ["can't be blank"]
    end
  end

  describe "relations" do
    describe "videos" do
      before do
        @video = videos(:wonder_woman)
        customer = customers(:customer_one)
        @rental = Rental.new(customer: customer,
                             due_date: "2020-12-25")
      end

      it "can set the video using Video" do
        @rental.video = @video
        expect(@rental.video_id).must_equal @video.id
      end

      it "can set the video using video_id" do
        @rental.video_id = @video.id
        expect(@rental.video).must_equal @video
      end

      it "has a video" do
        rental = rentals(:rental_one)
        expect(rental).must_respond_to :video
        expect(rental.video).must_be_kind_of Video
      end

    end

    describe "customers" do
      before do
        video = videos(:wonder_woman)
        @customer = customers(:customer_one)
        @rental = Rental.new(video: video,
                             due_date: "2020-12-25")
      end
      it "has a customer" do
        rental = rentals(:rental_one)
        expect(rental).must_respond_to :customer
        expect(rental.customer).must_be_kind_of Customer
      end

      it "can set the customer using Customer" do
        @rental.customer = @customer
        expect(@rental.customer_id).must_equal @customer.id
      end

      it "can set the customer using customer_id" do
        @rental.customer_id = @customer.id
        expect(@rental.customer).must_equal @customer
      end
    end
  end
end
