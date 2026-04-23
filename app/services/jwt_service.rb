# app/services/jwt_service.rb
class JwtService
  SECRET = Rails.application.credentials.secret_key_base

  def self.encode(payload)
    payload[:exp] = 24.hours.from_now.to_i
    payload[:iat] = Time.now.to_i
    JWT.encode(payload, SECRET)
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET)[0]

    if decoded["exp"] && Time.now.to_i > decoded["exp"]
      return nil
    end

    decoded
  rescue
    nil
  end
end
