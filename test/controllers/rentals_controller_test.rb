require "test_helper"

describe RentalsController do
  describe "check out" do
    before do
      @customer = customers(:customer_one)
      @video = videos(:wonder_woman)

      @params_hash = { customer_id: @customer.id, video_id: @video.id }

    end

    it "can successfully create a rental, updating customer's/video's counts" do

      customer_video_count = @customer.videos_checked_out_count
      video_inventory_count = @video.available_inventory

      expect {
        post check_out_path, params: @params_hash
      }.must_change "Rental.count", 1

      must_respond_with :ok

      body = JSON.parse(response.body)

      # expect(body["due_date"]).must_equal "#{render_date(DateTime.now + 1.week)}" #TODO make this work
      expect(body["videos_checked_out_count"]).must_equal customer_video_count + 1
      expect(body["available_inventory"]).must_equal video_inventory_count - 1
    end

    it "will display a 404 status code if supplied invalid customer" do

      @params_hash[:customer_id] = -1

      expect {
        post check_out_path, params: @params_hash
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include  "Not Found"
      must_respond_with :not_found
    end

    it "will display a 404 status code if supplied invalid video" do

      @params_hash[:video_id] = -1

      expect {
        post check_out_path, params: @params_hash
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include  "Not Found"
      must_respond_with :not_found
    end

    it "will display a 400 status code if video's inventory is too low to checkout" do

      @video.update(available_inventory: 0)

      expect {
        post check_out_path, params: @params_hash
      }.wont_change "Rental.count"

      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include  "Bad Request"
      must_respond_with :bad_request
    end

  end


  describe "check in" do
    before do

      @customer = customers(:customer_one)
      @video = videos(:wonder_woman)

      @params_hash = { customer_id: @customer.id, video_id: @video.id }
      @rental = Rental.create!(customer_id: @customer.id, video_id: @video.id, due_date: "12-11-20")
    end

    it "can successfully checkin a rental, updating customer's/video's counts" do

      customer_video_count = @customer.videos_checked_out_count
      video_inventory_count = @video.available_inventory

      post check_in_path, params: @params_hash

      body = JSON.parse(response.body)

      expect(body["videos_checked_out_count"]).must_equal customer_video_count - 1
      expect(body["available_inventory"]).must_equal video_inventory_count + 1
    end

    it "will display a 404 status code if supplied invalid customer" do
      @params_hash[:customer_id] = -1

      post check_in_path, params: @params_hash

      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include  "Not Found"
      must_respond_with :not_found
    end

    it "will display a 404 status code if supplied invalid video" do
      @params_hash[:video_id] = -1

      post check_in_path, params: @params_hash

      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include  "Not Found"
      must_respond_with :not_found
    end

  end

end
