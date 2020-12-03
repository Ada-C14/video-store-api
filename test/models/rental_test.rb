require "test_helper"

describe Rental do
  let(:customer) { customers(:customer_one) }
  let(:video) { videos(:released_movie) }

  let(:rental) {
    Rental.new(
      customer: customer,
      video: video,
      due_date: DateTime.now + 7)
  }

  it "is valid when fields are present" do
    expect(rental.valid?).must_equal true
  end

  it "is invalid without a customer" do
    rental.customer = nil

    check_invalid(model: rental, attribute: :customer)
    expect(rental.errors.messages[:customer]).must_include "must exist"
  end

  it "is invalid without a video" do
    rental.video = nil

    check_invalid(model: rental, attribute: :video)
    expect(rental.errors.messages[:video]).must_include "must exist"
  end

  it "is invalid without a due date" do
    rental.due_date = nil

    check_invalid(model: rental, attribute: :due_date)
    expect(rental.errors.messages[:due_date]).must_include "can't be blank"
  end

  it "is invalid if video's release date is in the future" do
    video.release_date = DateTime.now + 1
    video.save

    check_invalid(model: rental, attribute: :due_date)
    expect(rental.errors.messages[:due_date]).must_include "can't rent unreleased movies"
  end
end
