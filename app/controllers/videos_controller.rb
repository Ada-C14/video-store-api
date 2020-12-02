# frozen_string_literal: true
class VideosController < ApplicationController
  def index
    videos = Video.all.as_json(only: %i[id
                                      title
                                      release_date
                                      available_inventory])
    render json: videos, status: :ok
  end

  def show

    video = Video.find_by_id(params[:id]).as_json(only: %i[title
                                                         overview
                                                         release_date
                                                         total_inventory
                                                         available_inventory])
    if video.nil?
      render json: {errors: ['Not Found']}, status: :not_found
    else
      render json: video, status: :ok
    end
  end

  def create
    video = Video.new(video_params)

    if video.save
      render json: video.as_json(only: [:id]), status: :created
      nil
    else
      render json: {errors: video.errors.messages}, status: :bad_request
    end
  end

  private

  def video_params
    params.permit(:id, :title, :release_date, :available_inventory, :overview, :total_inventory)
  end
end
