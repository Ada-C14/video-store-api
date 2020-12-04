require "test_helper"

describe VideosController do
  def check_response(expected_type:, expected_status: :success)
    must_respond_with expected_status
    expect(response.header["Content-Type"]).must_include "json"

    body = JSON.parse(response.body)
    expect(body).must_be_kind_of expected_type
    return body
  end

  describe "index" do
    # Check that each customer has the proper keys
    INDEX_FIELDS = ["id", "title", "release_date", "available_inventory"].sort

    it "must get index" do
      # Act
      get videos_path
      body = check_response(expected_type: Array)

      # Assert
      expect(body.length).must_equal Video.count

      body.each do |customer|
        expect(customer.keys.sort).must_equal INDEX_FIELDS
      end
    end

    it "works even with no videos" do
      # Arrange
      Video.destroy_all

      # Act
      get videos_path

      # Assert
      body = check_response(expected_type: Array)
      expect(body.length).must_equal 0
    end
  end

  describe "show" do
    SHOW_FIELDS = ["title", "overview", "release_date", "total_inventory", "available_inventory"].sort

    it "can get a video" do
      # Arrange
      wonder_woman = videos(:wonder_woman)

      # Act
      get video_path(wonder_woman.id)

      # Assert
      body = check_response(expected_type: Hash)
      expect(body.keys.sort).must_equal SHOW_FIELDS
      expect(body["title"]).must_equal "Wonder Woman 2"
      expect(body["release_date"]).must_equal "2020-12-25"
      expect(body["available_inventory"]).must_equal 100
      expect(body["overview"]).must_equal "Wonder Woman squares off against Maxwell Lord and the Cheetah, a villainess who possesses superhuman strength and agility."
      expect(body["total_inventory"]).must_equal 100
    end

    it "responds with a 404 for non-existant videos" do
      # Act
      get video_path(-1)

      # Assert
      body = check_response(expected_type: Hash, expected_status: :not_found)
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_include "Not Found"
    end
  end

  describe "create" do
    before do
      @video_hash = {
        title: "Alf the movie",
        overview: "The most early 90s movie of all time",
        release_date: "2025-12-16",
        total_inventory: 6,
        available_inventory: 6,
      }
    end

    it "can create a valid video" do
      # Assert
      expect {
        post videos_path, params: @video_hash
      }.must_change "Video.count", 1

      check_response(expected_type: Hash, expected_status: :created)
    end

    it "will respond with bad request and errors for an invalid movie" do
      @video_hash[:title] = nil

      # Assert
      expect {
        post videos_path, params: @video_hash
      }.wont_change "Video.count"

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body.keys).must_include "errors"
      expect(body["errors"].keys).must_include "title"
      expect(body["errors"]["title"]).must_include "can't be blank"
    end
  end
end
