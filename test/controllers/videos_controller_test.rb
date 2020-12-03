require "test_helper"

REQUIRED_VIDEO_FIELDS = ['id', 'title', 'release_date', 'available_inventory']

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
      expect(video.keys.sort).must_equal REQUIRED_VIDEO_FIELDS
    end

  end

  it 'will respond with an empty array when there are no videos' do
    Video.destroy_all

    get videos_path

    body = check_response(expected_type: Array, expected_status: :ok)
    expect(body).must_equal []
  end


  describe "show" do
    REQUIRED_VIDEO_FIELDS = ['title', 'overview', 'release_date', 'total_inventory','available_inventory'].sort
    it "will return a hash with the proper fields for an existing video" do
      video = videos(:wonder_woman)

      get video_path(video)

      body = check_response(expected_type: Hash)
      expect(body.keys.sort).must_equal REQUIRED_VIDEO_FIELDS
    end

    it "will return a 404 response with json for a non-existent pet" do
      get video_path(-1)

      body = check_response(expected_type: Hash, expected_status: 404)
      expect(body['ok']).must_equal false
      expect(body['message']).must_equal "Not found"
    end
  end
end
