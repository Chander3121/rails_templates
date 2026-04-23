class Api::V1::BaseController < ApplicationController
  before_action :authenticate_request

  private

  def authenticate_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    decoded = JwtService.decode(token)
    @current_user = User.find(decoded["user_id"]) if decoded
  rescue
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
