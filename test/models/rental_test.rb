require "test_helper"

describe Rental do

  let (:rental) {
    Rental.create!(customer_id: Customer.first.id, video_id: Video.first.id)
  }

  let (:customer) {
    Customer.first
  }

  let (:video) {
    Video.first
  }

  it 'can be instantiated' do
    expect(rental.valid?).must_equal true

    %w[due_date checked_out checked_in video_id customer_id].each do |field|
      expect(rental).must_respond_to field
    end
  end

  describe 'validations' do
    it 'must have a customer_id' do
      rental.customer_id = nil
      expect(rental.valid?).must_equal false
      expect(rental.errors.messages).must_include :customer_id
    end

    it 'must have a video_id' do
      rental.video_id = nil
      expect(rental.valid?).must_equal false
      expect(rental.errors.messages).must_include :video_id
    end
  end

  describe 'relationships' do
    it 'belongs to a customer' do
      rental
      expect(customer.rentals.count).must_equal 1

      customer.rentals.each do |rental|
        expect(rental).must_be_instance_of Rental
      end
    end

    it 'belongs to a video' do
      rental
      expect(video.rentals.count).must_equal 1

      video.rentals.each do |rental|
        expect(rental).must_be_instance_of Rental
      end
    end
  end

  describe 'custom methods' do
    describe 'initialize_rental' do
      it 'will update associations and set a due date and check out date' do
        orig_avail = rental.video.available_inventory
        orig_checked_out = rental.customer.videos_checked_out_count

        rental.initialize_rental
        expect(rental.video.available_inventory).must_equal orig_avail - 1
        expect(rental.customer.videos_checked_out_count).must_equal orig_checked_out + 1
        expect(rental.checked_out).must_equal Date.today
        expect(rental.due_date).must_equal Date.today + 7
      end
    end

    describe 'rental_checkin' do
      it 'will update associations and set a check in date' do
        orig_avail = rental.video.available_inventory
        orig_checked_out = rental.customer.videos_checked_out_count

        rental.rental_checkin
        expect(rental.video.available_inventory).must_equal orig_avail + 1
        expect(rental.customer.videos_checked_out_count).must_equal orig_checked_out - 1
        expect(rental.checked_in).must_equal Date.today
      end
    end
  end
end
