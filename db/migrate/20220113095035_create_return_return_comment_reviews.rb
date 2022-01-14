class CreateReturnReturnCommentReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :return_return_comment_reviews do |t|
      t.references :return_comment_review, null: false, foreign_key: true
      t.timestamps
    end
  end
end
