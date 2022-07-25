class HashtagArticle < ApplicationRecord
  belongs_to :article
  belongs_to :hashtag
end
