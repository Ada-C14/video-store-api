require "test_helper"

describe RentalsController do
  before do
    @video = videos(:wonder_woman)
    @customer = customers(:customer_one)
  end

  let(:rental_params) {
    {
        video_id: @video.id,
        customer_id: @customer.id,
        due_date: Date.today + 1.week
    }
  }

  let(:checkin_params) {
    {
        video_id: @video.id,
        customer_id: @customer.id,
    }
  }

  REQUIRED_FIELDS = ["customer_id", "video_id", "due_date", "videos_checked_out_count", "available_inventory"].sort

  def check_response(expected_type:, expected_status: :success)
    must_respond_with expected_status
    expect(response.header['Content-Type']).must_include 'json'

    body = JSON.parse(response.body)
    expect(body).must_be_kind_of expected_type
    return body
  end


  describe "check_out" do

    it "responds with JSON and success" do

      post checkout_path, params: rental_params

      check_response(expected_type: Hash)
    end

    it "responds with a hash with the required rental info" do
      # Act
      post checkout_path, params: rental_params

      customer = Customer.find_by(id: @customer.id)
      video = Video.find_by(id: @video.id)
      # Assert
      body = check_response(expected_type: Hash)
      expect(body).must_be_instance_of Hash
      expect(body.keys.sort).must_equal REQUIRED_FIELDS
      expect(body["customer_id"]).must_equal customer.id
      expect(body["video_id"]).must_equal video.id
      expect(body["due_date"]).must_equal (Date.today + 1.week).as_json
    end

    it "creates a new rental and responds with 200 status (:ok)" do
      expect {
        post checkout_path, params: rental_params
      }.must_differ "Rental.count", 1

      must_respond_with :ok
    end

    it "it decreases the video's available_inventory by 1" do
      post checkout_path, params: rental_params

      video = Video.find_by(id: @video.id)
      expect(video.available_inventory).must_equal 99
    end

    it "it increases the customer's videos_checked_out_count by 1" do
      post checkout_path, params: rental_params

      customer = Customer.find_by(id: @customer.id)

      expect(customer.videos_checked_out_count).must_equal 4
    end

    it "will respond with 404 when there are no customers" do
      # Arrange
      Customer.destroy_all

      # Act
      post checkout_path, params: rental_params

      # Assert
      must_respond_with :not_found
    end

    it "will respond with 404 when there are no videos" do
      # Arrange
      Video.destroy_all

      # Act
      post checkout_path, params: rental_params

      # Assert
      must_respond_with :not_found
    end

  end

  describe "check_in" do

    it "responds with JSON and success" do

      post checkin_path, params: checkin_params

      check_response(expected_type: Hash)
    end

    it "responds with a hash with the required rental info" do
      # Act
      post checkin_path, params: checkin_params

      customer = Customer.find_by(id: @customer.id)
      video = Video.find_by(id: @video.id)
      # Assert
      body = check_response(expected_type: Hash)
      expect(body).must_be_instance_of Hash
      expect(body["customer_id"]).must_equal customer.id
      expect(body["video_id"]).must_equal video.id
    end

    it "this rental persists and does not create a new rental, responds with 200 status (:ok)" do
      expect {
        post checkin_path, params: checkin_params
      }.wont_differ "Rental.count"

      must_respond_with :ok
    end

    it "it increases the video's available_inventory by 1" do
      post checkin_path, params: checkin_params

      video = Video.find_by(id: @video.id)
      expect(video.available_inventory).must_equal 101
    end

    it "it decreases the customer's videos_checked_out_count by 1" do
      post checkin_path, params: checkin_params

      customer = Customer.find_by(id: @customer.id)

      expect(customer.videos_checked_out_count).must_equal 2
    end
  end

end
