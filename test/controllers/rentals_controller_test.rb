require "test_helper"

describe RentalsController do

  describe "check out" do
    it "creates a valid rental" do
      customer = customers(:customer_one)
      video = videos(:video_one)

      rental_hash = {
          customer_id: customer.id,
          video_id: video.id,
          returned: false,
          check_out_date: Date.today,
          due_date: Date.today + 7.days,
      }

      expect {
        post checkout_path, params: rental_hash
      }.must_change "Rental.count", 1

      must_respond_with :ok
    end

    it "responds with a not found for an invalid customer id" do
      video = videos(:video_one)
      rental_hash = {
          customer_id: nil,
          video_id: video.id,
          returned: false,
          check_out_date: Date.today,
          due_date: Date.today + 7.days
      }

      expect {
        post checkout_path, params: rental_hash
      }.wont_change "Rental.count"

      must_respond_with :not_found
      body = JSON.parse(response.body)
      expect(body['errors']).must_equal ['Not Found']
    end
  end
end
