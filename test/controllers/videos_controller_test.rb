require "test_helper"
require 'date'

describe VideosController do
  describe "index" do
    it "must get index" do
      # Act
      get videos_path
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal Video.count

      # Check that each customer has the proper keys
      fields = ["id", "title", "release_date", "available_inventory"].sort

      body.each do |customer|
        expect(customer.keys.sort).must_equal fields
      end

      must_respond_with :ok
    end

    it "works even with no videos" do
      # Arrange
      Video.destroy_all

      # Act
      get videos_path
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal 0

      must_respond_with :ok
    end
  end

  describe "show" do
    it "can get a video" do
      # Arrange
      wonder_woman = videos(:wonder_woman)

      # Act
      get video_path(wonder_woman.id)
      body = JSON.parse(response.body)

      # Assert
      fields = ["title", "overview", "release_date", "total_inventory", "available_inventory"].sort
      expect(body.keys.sort).must_equal fields
      expect(body["title"]).must_equal "Wonder Woman 2"
      expect(body["release_date"]).must_equal "2020-12-25"
      expect(body["available_inventory"]).must_equal 100
      expect(body["overview"]).must_equal "Wonder Woman squares off against Maxwell Lord and the Cheetah, a villainess who possesses superhuman strength and agility."
      expect(body["total_inventory"]).must_equal 100
      
      must_respond_with :ok
    end

    it "responds with a 404 for non-existant videos" do
      # Act
      get video_path(-1)

      # Assert
      must_respond_with :not_found
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body["ok"]).must_equal false
      expect(body["message"]).must_equal "Not found"
    end
  end

  describe "create" do
    it "can create a valid video" do
      # Arrange
      video_hash = {
        title: "Alf the movie",
        overview: "The most early 90s movie of all time",
        release_date: "December 16th 2025",
        total_inventory: 6,
        available_inventory: 6
      }

      # Assert
      expect {
        post videos_path, params: video_hash
      }.must_change "Video.count", 1

      must_respond_with :created
    end

    it "will respond with bad request and errors for an invalid movie" do
      # Arrange
      video_hash = {
            title: "Alf the movie",
            overview: "The most early 90s movie of all time",
            release_date: "December 16th 2025",
            total_inventory: 6,
            available_inventory: 6
      }
  
      video_hash[:title] = nil
  
      # Assert
      expect {
        post videos_path, params: video_hash
      }.wont_change "Video.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"].keys).must_include "title"
      expect(body["errors"]["title"]).must_include "can't be blank"
  
      must_respond_with :bad_request
    end
  end

  describe "checkout" do
    it "will checkout a video to a customer with valid ids" do

      customer = customers(:customer_one)
      video = videos(:wonder_woman)
      rental_hash = {
          video_id: video.id,
          customer_id: customer.id,
          due_date: Date.today + 7,
          videos_check_out_count: 4,
          available_inventory: 99
      }
      expect {post checkout_path, params: rental_hash}.must_change "Rental.count", 1
      must_respond_with :ok

      body = JSON.parse(response.body)
      expect(body["customer_id"]).must_equal customer.id
      expect(body["video_id"]).must_equal video.id
    end
  end

  describe "checkin" do
    before do
      @customer = customers(:customer_one)
      @video = videos(:wonder_woman)
      rental_hash = {
          video_id: @video.id,
          customer_id: @customer.id,
          due_date: Date.today + 7
      }
      post checkout_path, params: rental_hash

      @checkin_hash = {
          video_id: @video.id,
          customer_id: @customer.id,
      }
    end

    it "will respond with 404 with invalid customer id" do
      @checkin_hash[:customer_id] = -1
      count = @customer.videos_checked_out_count

      post checkin_path, params: @checkin_hash
      must_respond_with :not_found
      expect(@customer.videos_checked_out_count).must_equal count

    end

    it "will respond with 404 with invalid video id" do
      @checkin_hash[:video_id] = -1
      count = @customer.videos_checked_out_count

      post checkin_path, params: @checkin_hash
      must_respond_with :not_found
      expect(@customer.videos_checked_out_count).must_equal count
    end

    it "will decrease customer.videos_checked_out_count by one" do
      count = @customer.videos_checked_out_count

      post checkin_path, params: @checkin_hash
      @customer.reload
      must_respond_with :ok
      expect(@customer.videos_checked_out_count).must_equal count - 1
    end

    it "will increase video.available_inventory by one" do
      count = @video.available_inventory

      post checkin_path, params: @checkin_hash
      @video.reload
      must_respond_with :ok
      expect(@video.available_inventory).must_equal count + 1
    end


  end
end
