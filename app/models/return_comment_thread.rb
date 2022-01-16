class ReturnCommentThread < ApplicationRecord

  has_many :return_return_comment_threads,dependent: :destroy
  has_many :return_returns,through: :return_return_comment_threads,source: :return_return_thread,dependent: :destroy
  has_many :reverse_of_return_return_comment_threads,class_name:'ReturnReturnCommentThread',foreign_key:'return_return_thread_id'
  has_many :rereturn_returns,through: :reverse_of_return_return_comment_threads,source: :return_comment_thread,dependent: :destroy
  
end