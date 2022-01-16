class CreateLikeReturnCommentThreads < ActiveRecord::Migration[6.1]
  def change
    create_table :like_return_comment_threads do |t|
      t.references :return_comment_thread, null: false, foreign_key: true
      t.references :user, null: false,foreign_key: true,unique: true
      t.integer :goodbad,null: false
      t.timestamps
    end
  end
end
