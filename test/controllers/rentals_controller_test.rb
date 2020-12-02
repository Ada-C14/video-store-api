require "test_helper"

describe RentalsController do
  describe "check_out" do
    before do
      @video = videos(:wonder_woman)
      @customer = customers(:customer_one)
    end


    let(:rental_params) {
      {
        rental: {
          video_id: @video.id,
          customer_id: @customer.id
        }
      }
    }

    it "creates a new rental" do
      expect {
        post check_out_path, params: rental_params
      }.must_differ "Rental.count", 1

      must_respond_with :created
    end
  end
end
