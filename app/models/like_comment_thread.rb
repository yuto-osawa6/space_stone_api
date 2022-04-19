class LikeCommentThread < ApplicationRecord
  belongs_to :comment_thread
  belongs_to :user
  validates_uniqueness_of :comment_thread_id, scope: :user_id
end
