require "test_helper"

describe RentalsController do
  # it "must get create" do
  #   get rentals_create_url
  #   must_respond_with :success
  # end

  describe 'check_in' do
    it 'can check-in a video that was checked out' do

    end

    it 'increases a video available inventory count by 1 when checked in' do

    end

    it 'decreases a customer videos_checked_out_count by 1 when checked in' do

    end

    it 'sends a bad_request for an invalid customer' do

    end

    it 'sends a bad_request for an invalid video' do

    end

    it 'sends a not_found status for a rental that does not exist' do

    end
  end
end
