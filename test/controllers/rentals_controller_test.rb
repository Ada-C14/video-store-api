require "test_helper"

describe RentalsController do
  it "must get index" do
    get rentals_index_url
    must_respond_with :success
  end

  it "must get show" do
    get rentals_show_url
    must_respond_with :success
  end

  describe "rental checkout" do
    it 'increase the customer videos_checked_out_count by one' do
      
    end

    it "decrease the video's available_inventory by one" do

    end

    it 'should create a due date, 7 days from checkout date' do

    end

    it 'return back detailed errors and a status 404: Not Found if the customer does not exist' do

    end

    it 'return back detailed errors and a status 404: Not Found if the video does not exist' do

    end

    it 'return back detailed errors and a status 400: Bad Request if the video does not have any available inventory before check out ' do

    end
  end

  describe "rental check-in" do

    it "decrease the customer's videos_checked_out_count by one" do

    end

    it "increase the video's available_inventory by one" do

    end

    it "should return detailed errors and status 404 if the customer does not exist" do

    end

    it "should return detailed errors and a status of 404 if the video does not exist" do

    end



  end

end
