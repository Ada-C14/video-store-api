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

    it "creates a new rental and responds with 200 status (:ok)" do
      expect {
        post check_out_path, params: rental_params
      }.must_differ "Rental.count", 1

      must_respond_with :ok
    end

    it "it decreases the video's available_inventory by 1" do
      available_inventory = @video.available_inventory
      post check_out_path, params: rental_params

      video = Video.find_by(id: @video.id)

      expect(video.available_inventory).must_equal available_inventory - 1
    end

    it "it increases the customer's videos_checked_out_count by 1" do
      checked_out_count = @customer.videos_checked_out_count
      post check_out_path, params: rental_params

      customer = Customer.find_by(id: @customer.id)

      expect(customer.videos_checked_out_count).must_equal checked_out_count + 1
    end

    it "responds with 'Not Found' if customer is nil" do
      @customer.id = -1

      expect {
        post check_out_path, params: rental_params
      }.wont_change "Rental.count"

      must_respond_with :not_found
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['errors']).must_include 'Not Found'
    end

    it "responds with 'Not Found' if video is nil" do
      @video.id = -1

      expect {
        post check_out_path, params: rental_params
      }.wont_change "Rental.count"

      must_respond_with :not_found
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['errors']).must_include 'Not Found'
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

    it "it responds with 200 status (:ok)" do
      post check_in_path, params: rental_params

      must_respond_with :ok
    end

    it "it increases the video's available_inventory by 1" do
      available_inventory = @video.available_inventory

      post check_in_path, params: rental_params

      video = Video.find_by(id: @video.id)

      expect(video.available_inventory).must_equal available_inventory + 1
    end

    it "it decreases the customer's videos_checked_out_count by 1" do
      checked_out_count = @customer.videos_checked_out_count

      post check_in_path, params: rental_params

      customer = Customer.find_by(id: @customer.id)

      expect(customer.videos_checked_out_count).must_equal checked_out_count - 1
    end

    it "if rental is nil responds with 'Not Found'" do
      @customer.id = -1
      @video.id = -1

      post check_in_path, params: rental_params

      must_respond_with :not_found
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['errors']).must_include 'Not Found'
    end

    it "responds with 'Not Found' if customer is nil" do
      @customer.id = -1

      expect {
        post check_in_path, params: rental_params
      }.wont_change "Rental.count"

      must_respond_with :not_found
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['errors']).must_include 'Not Found'
    end

    it "responds with 'Not Found' if video is nil" do
      @video.id = -1

      expect {
        post check_in_path, params: rental_params
      }.wont_change "Rental.count"

      must_respond_with :not_found
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['errors']).must_include 'Not Found'
    end
  end
end
