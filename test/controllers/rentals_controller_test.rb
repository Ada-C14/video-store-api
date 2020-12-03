require "test_helper"

describe RentalsController do
  describe "check_out" do
    before do
      @video = videos(:wonder_woman)
      @customer = customers(:customer_one)
    end

    let(:rental_params) {
      {
        video_id: @video.id,
        customer_id: @customer.id
      }
    }

    it "has the required fields" do
      post check_out_path, params: rental_params
      body = JSON.parse(response.body)

      fields = ["customer_id", "video_id", "due_date", "videos_checked_out_count", "available_inventory"].sort

      customer = Customer.find_by(id: @customer.id)
      video = Video.find_by(id: @video.id)

      expect(body.keys.sort).must_equal fields
      expect(body["customer_id"]).must_equal customer.id
      expect(body["video_id"]).must_equal video.id
      expect(body["due_date"]).must_equal (Date.today + 1.week).as_json
      expect(body["videos_checked_out_count"]).must_equal customer.videos_checked_out_count
      expect(body["available_inventory"]).must_equal video.available_inventory
    end

    it "creates a new rental" do
      expect {
        post check_out_path, params: rental_params
      }.must_differ "Rental.count", 1

      must_respond_with :ok
    end

    it "responds with 'Not Found' if customer is nil" do
      @customer.id = -1

      expect {
        post check_out_path, params: rental_params
      }.wont_change "Rental.count"

      must_respond_with :not_found
    end

    it "responds with 'Not Found' if video is nil" do
      @video.id = -1

      expect {
        post check_out_path, params: rental_params
      }.wont_change "Rental.count"

      must_respond_with :not_found
    end
  end

  describe "check_in" do
    before do
      @video = videos(:wonder_woman)
      @customer = customers(:customer_one)
    end

    let(:rental_params) {
      {
          video_id: @video.id,
          customer_id: @customer.id
      }
    }

    it "has the required fields" do
      post check_out_path, params: rental_params

      post check_in_path, params: rental_params
      body = JSON.parse(response.body)

      fields = ["customer_id", "video_id", "videos_checked_out_count", "available_inventory"].sort

      customer = Customer.find_by(id: @customer.id)
      video = Video.find_by(id: @video.id)

      expect(body.keys.sort).must_equal fields
      expect(body["customer_id"]).must_equal customer.id
      expect(body["video_id"]).must_equal video.id
      expect(body["videos_checked_out_count"]).must_equal customer.videos_checked_out_count
      expect(body["available_inventory"]).must_equal video.available_inventory
    end

    it "if rental is nil responds with 'Not Found'" do
      @customer.id = -1
      @video.id = -1

      post check_in_path, params: rental_params

      must_respond_with :not_found
    end

    it "responds with 'Not Found' if customer is nil" do
      @customer.id = -1

      expect {
        post check_in_path, params: rental_params
      }.wont_change "Rental.count"

      must_respond_with :not_found
    end

    it "responds with 'Not Found' if video is nil" do
      @video.id = -1

      expect {
        post check_in_path, params: rental_params
      }.wont_change "Rental.count"

      must_respond_with :not_found
    end
  end
end
