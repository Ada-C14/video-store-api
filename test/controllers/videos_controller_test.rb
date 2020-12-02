require "test_helper"

REQUIRED_VIDEO_FIELDS = ['id', 'title', 'release_date', 'available_inventory'].sort

describe VideosController do
  it "must get index" do
    get videos_path
    must_respond_with :success
  end

  it 'responds with an array of video hashes' do
    get videos_path

    body = JSON.parse(response.body)

    expect(body).must_be_instance_of Array
    body.each do |video|
      expect(video).must_be_instance_of Hash
      required_video_attrs = ['id', 'title', 'release_date', 'available_inventory']
      expect(video.keys.sort).must_equal required_video_attrs.sort
    end

  end

  it 'will respond with an empty array when there are no videos' do
    Video.destroy_all

    get videos_path
    body = JSON.parse(response.body)

    expect(body).must_be_instance_of Array
    expect(body).must_equal []
  end


  describe "show" do
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
