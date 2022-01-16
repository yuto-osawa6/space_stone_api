class CreateReturnReturnCommentReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :return_return_comment_reviews do |t|
      t.references :return_comment_review, null: false, foreign_key: true
      t.references :return_return, foreign_key: { to_table: :return_comment_reviews }

      t.timestamps
    end
  end
end
