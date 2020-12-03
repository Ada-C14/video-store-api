require "test_helper"

REQUIRED_VIDEO_FIELDS = ['id', 'title', 'release_date', 'available_inventory'].sort

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



end
