class Product < ApplicationRecord
  has_many :cast_products
  has_many :casts, through: :cast_products

  has_many :janl_products
  has_many :janls, through: :janl_products

  has_many :style_products
  has_many :styles, through: :style_products

  has_many :likes
  has_many :liked_users, through: :likes, source: :user

end
