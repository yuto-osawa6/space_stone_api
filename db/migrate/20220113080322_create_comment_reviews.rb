class CreateCommentReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :comment_reviews do |t|
      t.references :review, null: false, foreign_key: true
      t.references :user, null: false,foreign_key: true
      # t.integer :goodbad,null: false
      t.text :comment,size: :long
      t.timestamps
    end
  end
end
