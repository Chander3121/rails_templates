# app/models/refresh_token.rb
class RefreshToken < ApplicationRecord
  belongs_to :user

  before_create :set_expiry

  def set_expiry
    self.expires_at = 7.days.from_now
  end

  def expired?
    Time.current > expires_at
  end
end