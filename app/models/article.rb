class Article < ApplicationRecord
  belongs_to :user

  has_many :article_products, dependent: :destroy
  has_many :products, through: :article_products, source: :product

  # 
  has_many :acsess_articles
end
