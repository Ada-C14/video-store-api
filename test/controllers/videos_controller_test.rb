require "test_helper"

describe VideosController do
  it "must get index" do
    get videos_index_url
    must_respond_with :success
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
