class CommentThread < ApplicationRecord
  belongs_to :thered
  belongs_to :user

  # has_many :like_comment_reviews,dependent: :destroy
  # has_many :like_comment_reviews_users,through: :like_comment_reviews,source: :user
  has_many :like_comment_threads,dependent: :destroy
  has_many :like_comment_threads_users,through: :like_comment_reviews,source: :user

  has_many :return_comment_threads, dependent: :destroy
  has_many :comment_threads_users, through: :return_comment_threads, source: :users

  scope :include_tp_img, -> { includes(user: {tp_img_attachment: :blob}) }
end
