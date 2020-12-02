require "test_helper"

describe VideosController do
  REQUIRED_VIDEO_FIELDS = ["title", "release_date", "available_inventory"]

  def check_response(expected_type:, expected_status: :success)
    must_respond_with expected_status
    expect(response.header['Content-Type']).must_include 'json'

    body = JSON.parse(response.body)
    expect(body).must_be_kind_of expected_type
    return body
  end
  
  describe "index" do
    it "must get index" do
      # Act
      get videos_path
      body = JSON.parse(response.body)

      # Assert
      expect(body).must_be_instance_of Array
      expect(body.length).must_equal Video.count

      # Check that each customer has the proper keys
      fields = REQUIRED_VIDEO_FIELDS.concat(["id"]).sort

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
      fields = REQUIRED_VIDEO_FIELDS.concat(["overview", "total_inventory"]).sort

      expect(body.keys.sort).must_equal fields
      expect(body["title"]).must_equal wonder_woman.title
      expect(body["release_date"]).must_equal wonder_woman.release_date
      expect(body["available_inventory"]).must_equal wonder_woman.available_inventory
      expect(body["overview"]).must_equal wonder_woman.overview
      expect(body["total_inventory"]).must_equal wonder_woman.total_inventory
      
      must_respond_with :ok
    end

    it "responds with a 404 for non-existant videos" do
      # Act
      get video_path(-1)
      body = JSON.parse(response.body)

      # Assert
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include  "Not Found"
      must_respond_with :not_found      
    end
  end

  describe "create" do
    before do
      # Arrange
      @video_hash = {
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
        post videos_path, params: @video_hash
      }.must_change "Video.count", 1

      must_respond_with :created
    end

    it "will respond with bad request and errors for an invalid movie" do
      # Arrange
      @video_hash[:title] = nil
  
      # Assert
      expect {
        post videos_path, params: @video_hash
      }.wont_change "Video.count"
      body = JSON.parse(response.body)

      expect(body.keys).must_include "errors"
      expect(body["errors"].keys).must_include "title"
      expect(body["errors"]["title"]).must_include "can't be blank"
  
      must_respond_with :bad_request
    end
  end
end
