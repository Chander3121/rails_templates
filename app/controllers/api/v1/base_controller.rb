class Api::V1::BaseController < ApplicationController
  include Authenticatable
  before_action :authenticate_request

  def me
    response = current_user ? {data: current_user, meta: {}, errors: []} : {data: nil, meta: {}, errors: []}
    render json: response
  end

  def unauthorized!
    render json: { errors: ["Unauthorized"] }, status: :unauthorized
  end
end
