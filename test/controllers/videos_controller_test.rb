require "test_helper"

describe VideosController do
  let(:video1) { videos(:wonder_woman) }
  let(:video2) { videos(:black_widow) }

  describe "index" do
    it "must get index" do
      # Act
      get videos_path
      body = JSON.parse(response.body)

      # Assert
      expect(response.header['Content-Type']).must_include 'json'
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal Video.count

      # Check that each customer has the proper keys
      fields = %w[id title release_date  available_inventory].sort

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

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal 0

      must_respond_with :ok
    end
  end


  describe "create" do
    let (:video_hash) do
     {
        title: "Alf the movie",
        overview: "The most early 90s movie of all time",
        release_date: "December 16th 2025",
        total_inventory: 6,
        available_inventory: 6
      }
    end
    it "can create a valid video" do
      # Assert
      expect {
        post videos_path, params: video_hash
      }.must_change "Video.count", 1

      must_respond_with :created
    end

    it "will respond with bad request and errors for an invalid movie" do
      # Arrange
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
    it "will respond with bad request and errors for a nil movie" do
      # Assert
      expect {
        post videos_path, params: nil
      }.wont_change "Video.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"].keys).must_include "title"
      expect(body["errors"]["title"]).must_include "can't be blank"

      must_respond_with :bad_request
    end
  end


  describe "show" do
    it "can get a video" do

      # Act
      get video_path(video1.id)
      body = JSON.parse(response.body)

      # Assert
      fields = %w[title overview release_date total_inventory available_inventory].sort
      expect(body.keys.sort).must_equal fields
      expect(body["title"]).must_equal "Wonder Woman 2"
      expect(body["release_date"]).must_equal "2020-12-25"
      expect(body["available_inventory"]).must_equal 100
      expect(body["overview"]).must_equal "Wonder Woman squares off against Maxwell Lord and the Cheetah, a villainess who possesses superhuman strength and agility."
      expect(body["total_inventory"]).must_equal 100

      must_respond_with :ok
    end

    it "responds with a 404 for nonexistent videos" do
      # Act
      get video_path(-1)
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal false
      expect(body["message"]).must_equal  "Video not found"
      must_respond_with :not_found
    end
  end


  describe "currently_checked_out_to" do
    it "can get route for existing, responds with :ok" do
      rentals(:rental_one)
      rentals(:rental_two)
      rentals(:rental_three)
      get video_current_customers_path(video1.id)

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal 2
      must_respond_with :ok
    end
    it "gets a descriptive error if video is not checked out to anyone, responds with :no_content" do
      get video_current_customers_path(videos(:out_of_stock).id)

      expect(response.header['Content-Type']).must_include 'json'
      body = JSON.parse(response.body)
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal true
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "This video is not currently checked out to any customer"

      must_respond_with :ok
    end
    it "responds with a 404 for nonexistent videos" do
      # Act
      get video_path(-1)
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_instance_of Hash
      expect(body['ok']).must_equal false
      expect(body["message"]).must_equal  "Video not found"
      must_respond_with :not_found
    end
  end

  describe "checkout_history" do
    it "can get route, responds with :ok" do
      get video_checkout_history_path

      must_respond_with :ok
    end
  end
end

