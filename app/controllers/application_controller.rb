class ApplicationController < ActionController::API

  def toggle_up_video_count(customer)
    video_count = customer.videos_checked_out_count += 1
    customer.save

    return video_count
  end



end
