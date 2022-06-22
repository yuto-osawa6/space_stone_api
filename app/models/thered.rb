class Thered < ApplicationRecord
  belongs_to :product
  belongs_to :user

  belongs_to :episord,optional:true

  has_many :thered_quesitons, dependent: :destroy
  has_many :questions, through: :thered_quesitons, source: :question
  # accepts_nested_attributes_for :thered_quesions, allow_destroy: true

  has_many :like_threads, dependent: :destroy
  has_many :like_threads_users, through: :like_threads, source: :user

  has_many :comment_threads, dependent: :destroy
  has_many :comment_threads_users, through: :comment_threads, source: :user

  has_many :acsess_threads, dependent: :destroy

  scope :include_bg_images, -> { includes(product: {bg_images_attachment: :blob}) }
  scope :include_tp_img, -> { includes(user: {tp_img_attachment: :blob}) }
end
