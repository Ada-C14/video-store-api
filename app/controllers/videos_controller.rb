class VideosController < ApplicationController
  def index
    videos = Video.all.order(:title)

    render json: videos.as_json(only: [:id, :title, :release_date,
                                     :available_inventory]),

           status: :ok
  end

  def create
    video = Video.new(video_params)
    if video.save
      render json: video.as_json(only: [:id]), status: :created
    else
      render json: {
          errors: video.errors.messages
      }, status: :bad_request
      return
    end
  end

  def zomg
    render json: { ok: 'it works' }, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])

    if video
      render json: video.as_json( only: [:title, :overview, :release_date, :total_inventory, :available_inventory]),
             status: :ok
      return
    else
      render json: {
          errors: ['Not Found']
      }, status: :not_found
      return
    end
  end

  def check_out
    new_rental = Rental.new(rental_params)
    new_rental.checkout_date = Date.today
    new_rental.due_date = Date.today + 7.days
    new_rental.returned = false
  end

  private

  def video_params
    return params.permit(:id, :title, :release_date, :overview, :total_inventory,
                                         :available_inventory)
  end

end
