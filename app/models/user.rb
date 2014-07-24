# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  email         :string(255)
#  display_name  :string(255)
#  password_hash :string(255)
#  password_salt :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  admin         :boolean
#

class User < ActiveRecord::Base
  obfuscate_id

  attr_accessor :password
  before_save :encrypt_password
  before_save :downcase_email

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_presence_of :display_name
  validates_uniqueness_of :email, case_sensitive: false

  has_many :entries, dependent: :destroy
  has_many :favorites
  has_many :stories, through: :entry

  def self.authenticate(email, password)
    user = find_by_email(email.downcase)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def downcase_email
    self.email = self.email.downcase
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

end
