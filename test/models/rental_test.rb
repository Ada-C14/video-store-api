require "test_helper"

describe Rental do

  it 'can be instantiated' do
    expect(video.valid?).must_equal true

    %w[title overview release_date total_inventory available_inventory].each do |field|
      expect(video).must_respond_to field
    end
  end

  describe 'validations' do
    it 'must have a title' do
      video.title = nil
      expect(video.valid?).must_equal false
      expect(video.errors.messages).must_include :title
    end
  end

  describe 'relationships' do

  end
end
