# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # extend Devise::Models 
  has_many :likes, dependent: :destroy
  has_many :liked_products, through: :likes, source: :product

  has_many :scores, dependent: :destroy
  has_many :scores_products, through: :scores, source: :product


  devise  :database_authenticatable, 
          :registerable,
          :recoverable, 
          :rememberable, 
          :trackable,
          :validatable,
          :omniauthable,
          omniauth_providers: [:google_oauth2]

  include DeviseTokenAuth::Concerns::User

  # has_many :likes, dependent: :destroy
  # has_many :liked_products, through: :likes, source: :product

  def self.signin_or_create_from_provider(provider_data)
    puts"vvvvvvvvvvvfffffffffffffffffffffffffffffff"
    puts provider_data
    puts "aaaaaaaaaaaa"
    puts provider_data[:provider]
    puts provider_data[:body][:provider]
    puts provider_data[:body][:info][:email]

    where(provider: provider_data[:body][:provider], uid: provider_data[:body][:uid]).first_or_create do |user|
      user.email = provider_data[:body][:info][:email]
      user.password = Devise.friendly_token[0, 20]
      # user.skip_confirmation! # when you signup a new user, you can decide to skip confirmation
    end
  end

  def already_liked?(id)
    self.likes.exists?(product_id: id)
  end

end
