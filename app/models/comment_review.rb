class CommentReview < ApplicationRecord
  belongs_to :review
  belongs_to :user

  has_many :like_comment_reviews,dependent: :destroy
  has_many :like_comment_reviews_users,through: :like_comment_reviews,source: :user

  has_many :return_comment_reviews, dependent: :destroy
  has_many :comment_reviews_users, through: :return_comment_reviews, source: :users

  # scope :goodbad_count do
  #   # query = '(SELECT COUNT(like_comment_reviews.comment_review_id) FROM like_comment_reviews where like_comment_reviews.comment_review_id = comment_reviews.id GROUP BY like_comment_reviews.comment_review_id)'
  #   # Arel.sql(query)
  # end
  scope :include_tp_img, -> { includes(user: {tp_img_attachment: :blob}) }
end
