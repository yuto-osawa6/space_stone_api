class LikeReturnCommentThread < ApplicationRecord
  belongs_to :return_comment_thread
  belongs_to :user
  validates_uniqueness_of :return_comment_thread_id, scope: :user_id
end
