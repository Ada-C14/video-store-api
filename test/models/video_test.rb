require "test_helper"

describe Video do
  it "confirms a video is valid when all fields are present" do
    video = Video.create(title:"Elf",
                         overview: "Will Ferrel at his best",
                         release_date: "2003-10-09",
                         total_inventory: 8,
                         available_inventory: 8
                        )

    expect(video.valid?).must_equal true
  end

  it "confirms a video is invalid when a field is missing" do
    video = Video.create()

    expect(video.valid?).must_equal false
    expect(video.errors.messages[:title]).must_equal ["can't be blank"]
    expect(video.errors.messages[:overview]).must_equal ["can't be blank"]
    expect(video.errors.messages[:release_date]).must_equal ["can't be blank"]
    expect(video.errors.messages[:total_inventory]).must_equal ["can't be blank", "is not a number"]
    expect(video.errors.messages[:available_inventory]).must_equal ["can't be blank", "is not a number"]
  end
end
