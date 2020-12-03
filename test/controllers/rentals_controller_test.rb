require "test_helper"

describe RentalsController do

  def check_response(expected_type:, expected_status: :success)
    # passed in status is expected
    must_respond_with expected_status
    # checking that it is json
    expect(response.header['Content-Type']).must_include 'json'

    body = JSON.parse(response.body)
    expect(body).must_be_kind_of expected_type
    return body
  end

  describe "check-out" do
    REQUIRED_FIELDS = %w[customer_id video_id due_date videos_checked_out_count available_inventory].sort

    let(:rental_info) {
      {
        customer_id: customers(:customer_one).id,
        video_id: videos(:wonder_woman).id
      }
    }

    it "returns success & appropriate response to valid params" do
      post check_out_path, params: rental_info

      body = check_response(expected_type: Hash,)
      expect(body.keys.sort!).must_equal REQUIRED_FIELDS
    end

    it "increases the customer's videos_checked_out_count by one" do
      customer = customers(:customer_one)
      expect(customer.videos_checked_out_count).must_equal 3
      post check_out_path, params: rental_info

      customer.reload
      expect(customer.videos_checked_out_count).must_equal 4

    end

    it "decreases the video's available-inventory by 1" do
      video = videos(:wonder_woman)
      expect(video.available_inventory).must_equal 100
      post check_out_path, params: rental_info

      video.reload
      expect(video.available_inventory).must_equal 99
    end

    it "returns bad_request if there's no inventory of video" do
      video = Video.find_by(id: rental_info[:video_id])
      video.update!(available_inventory: 0)

      post check_out_path, params: rental_info

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body["errors"]).must_include "available_inventory"

    end

    it "returns not_found if there is no valid customer_id" do

    end

    it "returns not_found if there is no valid video_id" do

    end
  end
end
