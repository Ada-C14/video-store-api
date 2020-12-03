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

  it "must get create" do
    get rentals_create_url
    must_respond_with :success
  end

end
