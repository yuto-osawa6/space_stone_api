class ReturnReturnCommentThread < ApplicationRecord
  belongs_to :return_comment_review
  belongs_to :return_return_thread, class_name: 'ReturnCommentThread'
end
