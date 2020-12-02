class VideosController < ApplicationController
  def index
  end

  def zomg
    render json: { ok: 'it works' }, status: :ok

  end


end
