class Question < ApplicationRecord
  has_many :thered_quesions, dependent: :destroy
  has_many :thered_question_thereds, through: :thered_quesions, source: :thered
end
