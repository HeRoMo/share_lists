class User < ActiveRecord::Base
  authenticates_with_sorcery!

  has_many :lists, foreign_key: :owner_id ,dependent: :destroy
  has_many :user_lists, dependent: :destroy
  has_many :favorite_lists ,through: :user_lists, source: :list

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  with_options on: :create do |create|
    create.validates :email, presence: true
    create.validates :password, presence: true
  end

  validates :password, length: { minimum: 3 }, unless: 'password.nil?'
  validates :password_confirmation, presence: true, unless: "password.nil?"
  validates :password, confirmation: true

  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  def admin?
    type == Admin::Type
  end
end
