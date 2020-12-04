require "test_helper"

describe RentalsController do
  before do
    @customer = customers(:customer_one)
    @video = videos(:wonder_woman)
  end

  describe "overdue" do
    it "can list all overdue books" do
      get overdue_path
    end
  end
  describe 'checkout' do
    it 'can create a new rental with valid fields' do
      initial_customer_rentals = @customer.videos_checked_out_count
      initial_video_inventory = @video.available_inventory

      rental_hash = {
          customer_id: @customer.id,
          video_id: @video.id,
      }

      expect{
        post checkout_path, params: rental_hash
      }.must_change 'Rental.count', 1

      rental = Rental.all.first

      # customer videos_checked_out should go + 1
      expect((initial_customer_rentals + 1) == @customer.reload.videos_checked_out_count).must_equal true

      # video inventory should go - 1
      expect((initial_video_inventory - 1) == @video.reload.available_inventory).must_equal true
    end

    it 'it will respond with not found and errors for invalid customer' do
      # Arrange
      rental_hash = {
          customer_id: -1,
          video_id: @video.id,
      }

      # Assert
      expect {
        post checkout_path, params: rental_hash
      }.wont_change "Rental.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"

      must_respond_with :not_found
    end

    it 'it will respond with not found and errors for invalid video' do
      # Arrange
      rental_hash = {
          customer_id: @customer.id,
          video_id: -1,
      }

      # Assert
      expect {
        post checkout_path, params: rental_hash
      }.wont_change "Rental.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"

      must_respond_with :not_found
    end
  end

  describe "check-in" do
    it "successfully checks in a video and correctly modifies customer and video data" do
      rental_hash = {
          customer_id: @customer.id,
          video_id: @video.id,
      }

      # checkout/create the rental first
      expect{
        post checkout_path, params: rental_hash
      }.must_change "Rental.count", 1

      initial_customer_rentals = @customer.reload.videos_checked_out_count
      initial_video_inventory = @video.reload.available_inventory

      expect{
        post check_in_path, params: rental_hash
      }.wont_change 'Rental.count'

      rental = Rental.find_by(video_id: @video.id, customer_id: @customer.id)

      expect((initial_customer_rentals - 1) == @customer.reload.videos_checked_out_count).must_equal true

      expect((initial_video_inventory + 1) == @video.reload.available_inventory).must_equal true

      body = JSON.parse(response.body)
      expect(body.keys).must_include "customer_id", "video_id"
      expect(body.keys).must_include "videos_checked_out_count", "available_inventory"
      must_respond_with :ok
    end

    it 'it will respond with not found and errors for invalid customer' do
      # Arrange
      rental_hash = {
          customer_id: -1,
          video_id: @video.id,
      }

      # Assert
      expect {
        post checkout_path, params: rental_hash
      }.wont_change @video.available_inventory

      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"

      must_respond_with :not_found
    end

    it 'it will respond with not found and errors for invalid video' do
      # Arrange
      rental_hash = {
          customer_id: @customer.id,
          video_id: -1,
      }

      # Assert
      expect {
        post checkout_path, params: rental_hash
      }.wont_change @customer.videos_checked_out_count

      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"

      must_respond_with :not_found
    end
  end
end
