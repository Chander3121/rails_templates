module Authenticatable
  def current_user
    return @current_user if @current_user

    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = JwtService.decode(token)

    @current_user = User.find(decoded["user_id"]) if decoded
  rescue
    nil
  end

  def authenticate_request
    unauthorized! unless current_user
  end
end
