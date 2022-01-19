class ArticleProduct < ApplicationRecord
  belongs_to :article
  belongs_to :product
end
