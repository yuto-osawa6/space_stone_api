class Product < ApplicationRecord
  has_many :cast_products
  has_many :casts, through: :cast_products

  has_many :janl_products
  has_many :janls, through: :janl_products

  has_many :style_products
  has_many :styles, through: :style_products

  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  has_many :scores, dependent: :destroy
  has_many :scores_users, through: :scores, source: :user

  has_many :acsesses, dependent: :destroy

  has_many :reviews, dependent: :destroy
  has_many :reviews_users, through: :reviews, source: :user

  has_many :thereds, dependent: :destroy
  has_many :thereds_users, through: :thereds, source: :user

end
