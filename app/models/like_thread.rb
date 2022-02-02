class LikeThread < ApplicationRecord
  belongs_to :thered
  belongs_to :user
  validates_uniqueness_of :thered_id, scope: :user_id
end
