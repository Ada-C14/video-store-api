require "test_helper"

describe RentalsController do
  let(:rental_params) {
    {
        customer_id: customers(:customer_one).id,
        video_id: videos(:wonder_woman).id
    }
  }
  describe "checkout" do
    it "can create a valid rental" do
      expect {
        post checkout_path, params: rental_params
      }.must_differ "Rental.count", 1

      must_respond_with :ok
    end

    it "will respond with 404 for an invalid video_id" do
      # Arrange  # Assert
      invalid_video_id = [nil, -1, "bogus"]
      invalid_video_id.each do |invalid_id|
        rental_params[:video_id] = invalid_id
        expect {
          post checkout_path, params: rental_params
        }.wont_change "Rental.count"
        body = JSON.parse(response.body)

        expect(body.keys).must_include "errors"
        expect(body["errors"]).must_include "Not Found"
        must_respond_with :not_found
      end
    end

    it "will respond with 404 for an invalid customer_id" do
      # Arrange  # Assert
      invalid_customer_id = [nil, -1, "bogus"]
      invalid_customer_id.each do |invalid_id|
        rental_params[:customer_id] = invalid_id
        expect {
          post checkout_path, params: rental_params
        }.wont_change "Rental.count"
        body = JSON.parse(response.body)

        expect(body.keys).must_include "errors"
        expect(body["errors"]).must_include "Not Found"
        must_respond_with :not_found
      end
    end

    it "will respond with 400 for an invalid available_inventory" do
      # Arrange  # Assert
      video = videos(:wonder_woman)
      video.available_inventory = 0
      video.save

      expect {
        post checkout_path, params: rental_params
      }.wont_change "Rental.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Bad Request"
      must_respond_with :bad_request
    end


    it "increase customer's videos checkout count by one" do
      # arrange
      customer_before = customers(:customer_one)
      before_count = customer_before.videos_checked_out_count
      # act
      post checkout_path, params: rental_params

      after_count = Customer.find_by(id: customer_before.id).videos_checked_out_count

      count_diff = after_count - before_count
      # assert
      expect(count_diff).must_equal 1
    end

    it "decrease the video's available_inventory by one" do
      # arrange
      video_before = videos(:wonder_woman)
      before_count = video_before.available_inventory
      # act
      post checkout_path, params: rental_params

      after_count = Video.find_by(id: video_before.id).available_inventory

      count_change = after_count - before_count
      # assert
      expect(count_change).must_equal -1
    end

    it "creates proper due date" do
      # arrange & # act
      post checkout_path, params: rental_params
      # assert
      rental = Rental.find_by(customer_id: customers(:customer_one).id, video_id: videos(:wonder_woman).id)
      expect(rental.due_date).must_equal Date.today + 7.days
    end
  end

  describe "check-in" do
    it "can checkin rental (verify valid rental)" do
      # arrange
      # checkout then checkin same rental
      post checkout_path, params: rental_params
      # act
      expect {
        post checkin_path, params: rental_params
      }.wont_change "Rental.count"

      must_respond_with :ok
      expect()
      # assert
    end

    it "will respond with 404 for an invalid video_id" do
      # Arrange  # Assert
      invalid_video_id = [nil, -1, "bogus"]
      invalid_video_id.each do |invalid_id|
        rental_params[:video_id] = invalid_id
        expect {
          post checkin_path, params: rental_params
        }.wont_change "Rental.count"
        body = JSON.parse(response.body)

        expect(body.keys).must_include "errors"
        expect(body["errors"]).must_include "Not Found"
        must_respond_with :not_found
      end
    end

    it "will respond with 404 for an invalid customer_id" do
      # Arrange  # Assert
      invalid_customer_id = [nil, -1, "bogus"]
      invalid_customer_id.each do |invalid_id|
        rental_params[:customer_id] = invalid_id
        expect {
          post checkin_path, params: rental_params
        }.wont_change "Rental.count"
        body = JSON.parse(response.body)

        expect(body.keys).must_include "errors"
        expect(body["errors"]).must_include "Not Found"
        must_respond_with :not_found
      end
    end

    it "decrease customer's videos checkout count by one" do
      # arrange
      post checkout_path, params: rental_params

      customer_before = Customer.find_by(id: customers(:customer_one).id)
      before_count = customer_before.videos_checked_out_count
      # act
      post checkin_path, params: rental_params

      after_count = Customer.find_by(id: customer_before.id).videos_checked_out_count

      count_diff = after_count - before_count
      # assert
      expect(count_diff).must_equal -1
    end

    it "increase the video's available_inventory by one" do
      # arrange
      post checkout_path, params: rental_params

      video_before = Video.find_by(id: videos(:wonder_woman).id)
      before_count = video_before.available_inventory
      # act
      post checkin_path, params: rental_params

      after_count = Video.find_by(id: video_before.id).available_inventory

      count_change = after_count - before_count
      # assert
      expect(count_change).must_equal 1
    end
  end
end
