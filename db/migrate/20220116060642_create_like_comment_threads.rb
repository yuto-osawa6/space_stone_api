class CreateLikeCommentThreads < ActiveRecord::Migration[6.1]
  def change
    create_table :like_comment_threads do |t|
      t.references :comment_thread, null: false, foreign_key: true
      t.references :user, null: false,foreign_key: true, unique: true
      t.integer :goodbad,null: false
      t.timestamps
    end
  end
end
