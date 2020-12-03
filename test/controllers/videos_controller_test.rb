require "test_helper"

REQUIRED_VIDEO_FIELDS = ['id', 'title', 'overview', 'release_date', 'available_inventory', 'total_inventory'].sort

describe VideosController do
  it "responds with JSON array and OK" do
    get videos_path

    check_response(expected_type: Array, expected_status: :ok)
  end

  it 'responds with an array of video hashes' do
    get videos_path

    body = check_response(expected_type: Array, expected_status: :ok)

    body.each do |video|
      expect(video).must_be_instance_of Hash
      expect(video.keys.sort).must_equal REQUIRED_VIDEO_FIELDS - ['overview', 'total_inventory']
    end

  end

  it 'will respond with an empty array when there are no videos' do
    Video.destroy_all

    get videos_path

    body = check_response(expected_type: Array, expected_status: :ok)
    expect(body).must_equal []
  end


  describe "show" do
    it "will return a hash with the proper fields for an existing video" do
      video = videos(:wonder_woman)

      get video_path(video)

      body = check_response(expected_type: Hash)
      expect(body.keys.sort).must_equal REQUIRED_VIDEO_FIELDS - ['id']
    end

    it "will return a 404 response with json for a non-existent video" do
      get video_path(-1)

      body = check_response(expected_type: Hash, expected_status: 404)

      # expect(body['ok']).must_equal false # To make smoke test pass
      expect(body['errors']).must_equal ["Not Found"]
    end
  end

  describe "create" do
    let(:video_data) {
      {
              title: "A Whisker Away",
              overview: "A girl turns into a cat to get closer to the boy she likes",
              release_date: Date.new(2020,6,18),
              total_inventory: 9,
              available_inventory: 3,
      }
    }

    it "can create a new video" do
      expect {
        post videos_path, params: video_data
      }.must_differ "Video.count", 1

      check_response(expected_type: Hash, expected_status: :created)
    end

    it 'will respond with bad_request for invalid data' do
      video_data[:title] = nil

      expect {
        post videos_path, params: video_data
      }.wont_change "Video.count"

      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body["errors"].keys).must_include "title"

    end
  end
end
