require "test_helper"

describe RentalsController do

  before do
    @simon = customers(:customer_one)
    @wonder_woman = videos(:wonder_woman)
  end
  describe "checkout" do
    it "can checkout" do
      checkout_params = {
        customer_id: @simon.id,
        video_id: @wonder_woman.id
      }
      
      expect {post checkout_path, params: checkout_params}.must_differ "Rental.count", 1

      body = JSON.parse(response.body)
      # check stuff in the body - customer/video ids are correct - customers video checked out + 1? and video available inventory - 1?

      must_respond_with :ok
    end

    it "returns back detailed errors and a status 404: Not Found if the customer does not exist" do
      skip
    end

    it "returns back detailed errors and a status 404: Not Found if the video does not exist" do
      skip
    end

    it "returns back detailed errors and a status 400: Bad Request if the video does not have any available inventory before check out" do
      skip
    end

  end
end