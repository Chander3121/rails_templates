class Api::V1::AuthController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_request, only: [:login, :refresh]

  def login
    user = User.find_by(email: params[:email])

    if user&.valid_password?(params[:password])
      access_token = JwtService.encode(user_id: user.id)

      refresh_token = user.refresh_tokens.create!(
        token: SecureRandom.hex(32)
      )

      render json: {
        data: {
          access_token: access_token,
          refresh_token: refresh_token.token
        },
        errors: []
      }
    else
      render json: { errors: ["Invalid credentials"] }, status: :unauthorized
    end
  end

  def refresh
    token = params[:refresh_token]

    token_record = RefreshToken.find_by(token: token)

    if token_record.nil?
      return unauthorized!
    end

    if token_record.expired?
      token_record.destroy
      return unauthorized!
    end

    user = token_record.user

    token_record.destroy

    new_refresh = user.refresh_tokens.create!(
      token: SecureRandom.hex(32)
    )

    access_token = JwtService.encode(user_id: user.id)

    render json: {
      data: {
        access_token: access_token,
        refresh_token: new_refresh.token
      },
      errors: []
    }
  end

  def logout
    token = params[:refresh_token]

    token_record = RefreshToken.find_by(token: token)

    if token_record.nil?
      return unauthorized!
    end

    token_record.destroy

    render json: {
      data: {
        message: "Logged out successfully"
      },
      errors: []
    }
  end
end
