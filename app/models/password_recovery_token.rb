class PasswordRecoveryToken < ActiveRecord::Base
  validate :token, presence: true
  validate :user, presence: true

  belongs_to :user
end
