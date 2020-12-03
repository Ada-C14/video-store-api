require "test_helper"

describe RentalsController do
  describe "check-out" do
    let (:rental_hash) {
      {     
        customer_id: customers(:customer_one).id,
        video_id: videos(:wonder_woman).id,
      }
    }  
    it "can check-out a valid rental" do
      # Arrange
      before_videos_count = customers(:customer_one).videos_checked_out_count
      before_inventory = videos(:wonder_woman).available_inventory

      fields = ["customer_id", "video_id", "due_date", "videos_checked_out_count", "available_inventory"].sort

      # Assert
      expect {
        post check_out_path, params: rental_hash
      }.must_differ "Rental.count", 1

      must_respond_with :ok

      body = JSON.parse(response.body)

      expect(body.keys.sort).must_equal fields

      expect(Date.parse(body["due_date"]) - Date.today).must_equal 7
      expect(body["videos_checked_out_count"]).must_equal before_videos_count + 1
      expect(body["available_inventory"]).must_equal before_inventory - 1
    end

    it "will respond with not found and errors for an invalid customer" do
      # Arrange
      rental_hash[:customer_id] = nil
  
      # Assert
      expect {
        post check_out_path, params: rental_hash
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Not Found"
  
      must_respond_with :not_found
    end

    it "will respond with not found and errors for an invalid video" do
      # Arrange
      rental_hash[:video_id] = nil
  
      # Assert
      expect {
        post check_out_path, params: rental_hash
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Not Found"
  
      must_respond_with :not_found
    end
  end
end
