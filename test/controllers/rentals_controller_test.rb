require "test_helper"

describe RentalsController do
  describe "check_out" do
    let(:rental_params) {
      {
          rental: {
              video: videos(:wonder_woman),
            customer: customers(:customer_one),
              # due_date: Date.new + 1.week
          }
      }
    }
    it "creates a new rental" do
      expect {
        post check_out_path, params: rental_params
      }.must_differ "Rental.count", 1

      must_respond_with :created
    end
  end
end
