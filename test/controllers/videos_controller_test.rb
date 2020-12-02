require "test_helper"

describe VideosController do
  it "must get index" do
    get videos_index_url
    must_respond_with :success
  end

  it 'responds with an array of video hashes' do
    get v

    body = JSON.parse(response.body)

    expect(body).must_be_instance_of Array
    body.each do |video|
      expect(video).must_be_instance_of Hash
      required_video_attrs = ['id', 'title', 'release_date', 'available_inventory']
      expect(video.keys.sort).must_equal required_video_attrs.sort
    end

  end

  it "must get show" do
    get videos_show_url
    must_respond_with :success
  end

  it "must get create" do
    get videos_create_url
    must_respond_with :success
  end

end
