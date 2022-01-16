class ReturnReturnCommentReview < ApplicationRecord
  belongs_to :return_comment_review
  belongs_to :return_return, class_name: 'ReturnCommentReview'
end
