class ReturnCommentReview < ApplicationRecord
  belongs_to :comment_review
  belongs_to :user
  # validates_uniqueness_of :comment_review_id, scope: :user_id

  has_many :like_return_comment_reviews,dependent: :destroy
  has_many :like_return_comment_reviews_users,through: :like_return_comment_reviews,source: :user

  has_many :return_return_comment_reviews,dependent: :destroy
  has_many :return_returns,through: :return_return_comment_reviews,source: :return_return,dependent: :destroy
  has_many :reverse_of_return_return_comment_reviews,class_name:'ReturnReturnCommentReview',foreign_key:'return_return_id'
  has_many :rereturn_returns,through: :reverse_of_return_return_comment_reviews,source: :return_comment_review,dependent: :destroy
  


  # has_many :relationships, dependent: :destroy
  # has_many :followings, through: :relationships, source: :follow, dependent: :destroy
  # has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id', dependent: :destroy
  # has_many :followers, through: :reverse_of_relationships, source: :user, dependent: :destroy

  # has_many :like_return_comment_reviews_users,through: :like_return_comment_reviews,source: :user
end
