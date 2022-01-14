class CreateLikeCommentReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :like_comment_reviews do |t|
      t.references :comment_review, null: false, foreign_key: true
      t.references :user, null: false,foreign_key: true, unique: true
      t.integer :goodbad,null: false
      t.timestamps
    end
  end
end
