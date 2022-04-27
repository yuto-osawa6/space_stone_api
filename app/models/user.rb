# frozen_string_literal: true

class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # extend Devise::Models 
  has_many :likes, dependent: :destroy
  has_many :liked_products, through: :likes, source: :product

  has_many :scores, dependent: :destroy
  has_many :scores_products, through: :scores, source: :product

  has_many :reviews, dependent: :destroy
  has_many :reviews_products, through: :reviews, source: :product

  has_many :thereds, dependent: :destroy
  has_many :thereds_products, through: :thereds, source: :product

  # review
  has_many :like_reviews, dependent: :destroy
  has_many :like_reviews_reviews, through: :like_reviews, source: :review

  has_many :comment_reviews, dependent: :destroy
  has_many :comment_reviews_reviews, through: :comment_reviews, source: :reviews

  has_many :return_comment_reviews, dependent: :destroy
  has_many :return_comment_reviews_users, through: :return_comment_reviews, source: :comment_reviews

  has_many :like_comment_reviews,dependent: :destroy
  has_many :like_comment_reviews_comment_reviews,through: :like_comment_reviews,source: :comment_review

  has_many :like_return_comment_reviews,dependent: :destroy
  has_many :like_return_comment_reviews_return_comment_reviews,through: :like_return_comment_reviews,source: :return_comment_review

  # thread
  has_many :like_threads, dependent: :destroy
  has_many :like_reviews_threads, through: :like_threads, source: :thered

  has_many :comment_threads, dependent: :destroy
  has_many :comment_reviews_threads, through: :comment_threads, source: :thered

  has_many :return_comment_threads, dependent: :destroy
  has_many :return_comment_reviews_users, through: :return_comment_threads, source: :comment_thread

  # like_comment_threads

  has_many :like_comment_threads,dependent: :destroy
  has_many :like_comment_threads_comment_threads,through: :like_comment_threads,source: :comment_thread

  # like_return_comment_threads
  has_many :like_return_comment_threads,dependent: :destroy
  has_many :like_return_comment_threads_return_comment_threads,through: :like_return_comment_threads,source: :return_comment_thread
  
  # article
  # doneyet-0(article書く人が増えたとき) dependent destroy
  has_many :articles

  # bacground image
  # doneyet base64方式に変更
  has_one_attached :bg_img

  # emotion
  has_many :review_emotions,dependent: :destroy
  has_many :emotions,through: :review_emotions, source: :emotion
  has_many :emotion_products,through: :review_emotions, source: :product
  has_many :emotion_episords,through: :review_emotions, source: :episord
  # has_many :users,through: :review_emotions , source: :user
  has_many :emotion_reviews,through: :review_emotions , source: :review

  # chats
  has_many :chats,dependent: :destroy
  has_many :products,through: :chats, source: :product

  # tier
  has_many :tiers,dependent: :destroy
  has_many :products,through: :tiers,source: :product
  has_many :tier_groups,through: :tiers,source: :tier_group
  has_many :user_tier_groups,through: :tiers,source: :user_tier_group


  # tier scope
  # has_many :group_tiers, -> { where tier_group_id:1 },class_name: "Tier"
  # has_many :group_tiers2, -> { group 'tier_groups.id' },through: :tier_group

  has_many :user_tier_groups,dependent: :destroy
  has_many :tier_groups,through: :user_tier_groups,source: :tier_group


  devise  :database_authenticatable, 
          :registerable,
          :recoverable, 
          :rememberable, 
          :trackable,
          :validatable,
          :omniauthable,
          omniauth_providers: [:google_oauth2]

  include DeviseTokenAuth::Concerns::User


  def image_url
    # 紐づいている画像のURLを取得する
    self.bg_img.attached? ? url_for(bg_img) : nil
  end

  def self.signin_or_create_from_provider(provider_data)
    where(provider: provider_data[:body][:provider], uid: provider_data[:body][:uid]).first_or_create do |user|
      user.email = provider_data[:body][:info][:email]
      user.password = Devise.friendly_token[0, 20]
      user.nickname =  provider_data[:body][:info][:name]
      user.image = provider_data[:body][:info][:image]
      # user.skip_confirmation! # when you signup a new user, you can decide to skip confirmation
    end
  end

  def already_liked?(id)
    self.likes.exists?(product_id: id)
  end

end
