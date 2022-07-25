class Article < ApplicationRecord
  belongs_to :user

  has_many :article_products, dependent: :destroy
  has_many :products, through: :article_products, source: :product

  has_many :hashtag_articles, dependent: :destroy
  has_many :hashtags, through: :hashtag_articles, source: :hashtag

  # 
  has_many :acsess_articles, dependent: :destroy
end
