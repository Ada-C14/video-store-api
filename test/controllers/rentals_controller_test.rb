require "test_helper"

describe RentalsController do
  describe "checkout" do

    let(:rental_params) {
      {
          customer_id: customers(:customer_one).id,
          video_id: videos(:wonder_woman).id
      }
    }

    it "can create a valid rental" do
      expect {
        post checkout_path, params: rental_params
      }.must_differ "Rental.count", 1

      must_respond_with :ok
    end

    it "will respond with bad request and errors for an invalid rental" do

      # Arrange
      rental_params[:customer_id] = nil

      # Assert
      expect {
        post checkout_path, params: rental_params
      }.wont_change "Rental.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      # expect(body["errors"].keys).must_include "customer_id"
      # expect(body["errors"]["customer_id"]).must_include "can't be blank"

      must_respond_with :not_found

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

    end

    it "creates proper due date" do

    end


  end
end
