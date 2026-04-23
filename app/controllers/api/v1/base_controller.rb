class Api::V1::BaseController < ApplicationController
  include Authenticatable

  def me
    response = current_user ? {data: current_user, meta: {}, errors: []} : {data: nil, meta: {}, errors: []}
    render json: response
  end
end
