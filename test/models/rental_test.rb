require "test_helper"

describe Rental do
  let (:rental_one) { rentals(:rental_one)}

  let (:rental_hash) do {
      customer_id: customers(:customer_two).id,
      video_id: videos(:wonder_woman).id,
      due_date: Date.today + 7.days
  }
  end

  describe "relationships" do
    it "belongs to customer" do
      customer = rental_one.customer
      expect(customer).must_be_instance_of Customer
      expect(customer.name).must_equal customers(:customer_one).name
    end

    it "belongs to video" do
      video = rental_one.video
      expect(video).must_be_instance_of Video
      expect(video.title).must_equal videos(:wonder_woman).title
    end
  end

  describe "validations" do
    it "has a due date" do
      rental_hash[:due_date] = nil
      rental = Rental.create(rental_hash)

      found_rental = Rental.find_by(customer_id: rental_hash[:customer_id], video_id: rental_hash[:video_id])
      expect(found_rental).must_be_nil
      expect(rental.valid?).must_equal false
      expect(rental.errors.keys).must_include :due_date
    end

    it "due date on checkout is on or after today's date" do
      rental_hash[:due_date] = Date.today - 3.days
      rental = Rental.create(rental_hash)

      found_rental = Rental.find_by(customer_id: rental_hash[:customer_id], video_id: rental_hash[:video_id])
      expect(found_rental).must_be_nil
      expect(rental.valid?).must_equal false
      expect(rental.errors.keys).must_include :due_date
    end

  end

end
