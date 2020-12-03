class VideosController < ApplicationController

  def index
    videos = Video.parameterized_list(params[:sort], params[:n], params[:p])

    render json: videos.as_json(only: [:id, :title, :release_date, :available_inventory]), status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])

    if video.nil?
      return render json: {ok: false, message: "Video not found", errors: ['Not Found']}, status: :not_found
    end

    render json: video.as_json(only: [:title, :overview, :release_date, :total_inventory, :available_inventory]), status: :ok
  end

  def create
    video = Video.new(video_params)

    if video.save
      render json: video.as_json(only: [:id]), status: :created
    else
      render json: {
          ok: false,
          errors: video.errors.messages
      }, status: :bad_request
      return
    end
  end

  def currently_checked_out_to
    rentals = self.rentals.filter { |rental| rental.updated_at < rental.due_date }
    customers = rentals.map { |rental| rental.customer }
    return customers.as_json(only: [:customer_id, :name, :postal_code, :checkout_date, :due_date]), status: :ok
  end

  def

  private

  def video_params
    params.permit(:title, :overview, :release_date, :total_inventory, :available_inventory)
  end
end
