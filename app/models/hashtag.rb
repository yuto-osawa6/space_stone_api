class Hashtag < ApplicationRecord
  has_many :hashtag_articles, dependent: :destroy
  has_many :articles, through: :hashtag_articles, source: :article
end
