require "test_helper"

describe RentalsController do
  describe "rental checkout" do
    # {
    #     customer_id: 1,
    #     video_id: 235040983,
    #     due_date: "2020-06-31",
    #     videos_checked_out_count: 2,
    #     available_inventory: 5
    # }
    before do
      @customer = customers(:customer_one)
      @video = videos(:wonder_woman)
      @rental = Rental.create(customer_id: @customer.id, video_id: @video.id, due_date: Time.now + (60*60*24*7))
      @rental_params = {
          customer_id: @customer.id,
          video_id: @video.id
      }
    end
    it 'increase the customer videos_checked_out_count by one' do
      expect {post checkout_path, params: @rental_params}.must_change "Rental.count", 1
    end

    it "decrease the video's available_inventory by one" do

    end

    it 'should create a due date, 7 days from checkout date' do

    end

    it 'return back detailed errors and a status 404: Not Found if the customer does not exist' do
      #Arrange
      rental_params_hash =
          {
              customer_id: nil,
              video_id: 235040983,
          }
      #Assert
      expect {
        post checkout_path, params: rental_params_hash
      }.wont_change "Rental.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include  "Not Found"
      must_respond_with :not_found
    end

    it 'return back detailed errors and a status 404: Not Found if the video does not exist' do

      #Arrange
      rental_params_hash =
          {
              customer_id: 1,
              video_id: nil,
          }
      #Assert
      expect {
        post checkout_path, params: rental_params_hash
      }.wont_change "Rental.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include  "Not Found"
      must_respond_with :not_found

    end

    it 'return back detailed errors and a status 400: Bad Request if the video does not have any available inventory before check out ' do

    end
  end

  describe "rental check-in" do

    it "decrease the customer's videos_checked_out_count by one" do

    end

    it "increase the video's available_inventory by one" do

    end

    it "should return detailed errors and status 404 if the customer does not exist" do

    end

    it "should return detailed errors and a status of 404 if the video does not exist" do

    end



  end

end
