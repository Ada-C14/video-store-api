class VideosController < ApplicationController
  before_action :find_video, only: [:show, :currently_checked_out_to, :checkout_history]

  def index
    videos = Video.parameterized_list(params[:sort], params[:n], params[:p])

    render json: videos.as_json(only: [:id, :title, :release_date, :available_inventory]), status: :ok
  end

  def show
    render json: @video.as_json(only: [:title, :overview, :release_date, :total_inventory, :available_inventory]), status: :ok
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
    customers = @video.currently_checked_out_to
    if customers.empty?
      render json: {
        ok: true,
        message: "This video is not currently checked out to any customer",
        errors: ["This video is not currently checked out to any customer"]
      }, status: :ok
    else
      render json: customers.as_json(only: [:customer_id, :name, :postal_code, :checkout_date, :due_date]), status: :ok
    end
  end

  def checkout_history

  end

  private

  def video_params
    params.permit(:title, :overview, :release_date, :total_inventory, :available_inventory)
  end

  def find_video
    @video = Video.find_by(id: params[:id])

    if @video.nil?
      return render json: {ok: false, message: "Video not found", errors: ['Not Found']}, status: :not_found
    end
  end

end
