require "test_helper"

describe CustomerController do
  it "must get index" do
    get customer_index_url
    must_respond_with :success
  end

  it "must get show" do
    get customer_show_url
    must_respond_with :success
  end

  it "must get create" do
    get customer_create_url
    must_respond_with :success
  end

end
