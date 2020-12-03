class VideosController < ApplicationController
  def index
    videos = Video.all.as_json(only: [:available_inventory, :id, :release_date, :title])
    render json: videos, status: :ok
  end

  def show
    video = Video.find_by(id: params[:id])

    if video.nil?
      render json: { #ok: false,
                     errors: ['Not Found']
      }, status: :not_found
      return
    end

    # formatted_date = video.release_date.to_formatted_s(:long_ordinal)
    # puts formatted_date
    # video.release_date = formatted_date

    render json: video.as_json(only: [:title, :overview, :release_date, :total_inventory, :available_inventory]),
           status: :ok
  end

  def create
    video = Video.new(title: params[:title],
                      overview: params[:overview],
                      release_date: params[:release_date],
                      total_inventory: params[:total_inventory],
                      available_inventory: params[:available_inventory])

    if video.save
      render json: video.as_json(only: [:id]), status: :created
      return
    else
      render json: {  #ok: false,
                    errors: video.errors.messages}, status: :bad_request
      return
    end

  end
end
