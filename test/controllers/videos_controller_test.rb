require "test_helper"

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



end
