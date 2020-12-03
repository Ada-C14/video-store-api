require "test_helper"

describe RentalsController do
  # describe "checking in" do
  #   let(:rental_hash) {
  #     {
  #         rental: {
  #             customer_id: 1000,
  #             video_id: 563782,
  #             checked_out: "Wed, 29 Apr 2015 07:54:14 -0700",
  #             due_date: "Wed, 06 May 2015 07:54:14 -0700",
  #             checked_in: "Wed, 03 May 2015 08:36:10 -0700"
  #         },
  #     }
  #   }
  #
  #   it "responds with a not_found if customer_id or video_id doesn't exist" do
  #
  #     rental_hash[:rental][:customer_id] = nil
  #     rental_hash[:rental][:video_id] = nil
  #
  #     expect {
  #       post check_in_path, params: rental_hash
  #     }.wont_change "Rental.count"
  #
  #     body = JSON.parse(response.body)
  #
  #     must_respond_with :not_found
  #     expect(body['errors'].keys).must_include "customer_id"
  #     expect(body['errors'].keys).must_include "video_id"
  #   end
  # end
end
