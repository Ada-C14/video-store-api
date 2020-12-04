require "test_helper"

describe Video do
  let (:wonder_woman) {videos(:wonder_woman)}
  it 'can be created' do
    expect(wonder_woman.valid?).must_equal true
    expect(wonder_woman).must_be_instance_of Video
  end

  it 'requires title, overview, release date, total inventory and available inventory' do
    required_fields = [:title, :overview, :release_date, :total_inventory, :available_inventory]

    required_fields.each do |field|
      wonder_woman[field] = nil

      expect(wonder_woman.valid?).must_equal false
      expect(wonder_woman.errors.messages[field]).must_include "can't be blank"

      wonder_woman.reload
    end
  end

  it 'requires a numeric value for total inventory' do
    wonder_woman.total_inventory = 'one'

    expect(wonder_woman.valid?).must_equal false
    expect(wonder_woman.errors.messages[:total_inventory]).must_include 'is not a number'
  end

  it 'requires the numeric value for total inventory to be equal or greater than 0' do
    wonder_woman.total_inventory = -1

    expect(wonder_woman.valid?).must_equal false
    expect(wonder_woman.errors.messages[:total_inventory]).must_include 'must be greater than or equal to 0'
  end

  it 'requires a numeric value for available inventory' do
    wonder_woman.available_inventory = 'one'

    expect(wonder_woman.valid?).must_equal false
    expect(wonder_woman.errors.messages[:available_inventory]).must_include 'is not a number'
  end

  it 'requires the numeric value for available inventory to be equal or greater than 0' do
    wonder_woman.available_inventory = -1

    expect(wonder_woman.valid?).must_equal false
    expect(wonder_woman.errors.messages[:available_inventory]).must_include 'must be greater than or equal to 0'
  end

end
