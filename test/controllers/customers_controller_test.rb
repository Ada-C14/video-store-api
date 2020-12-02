require "test_helper"

describe CustomersController do
  it "must get index" do
    get customers_index_url
    must_respond_with :success
  end

  it "must get show" do
    get customers_show_url
    must_respond_with :success
  end

end
