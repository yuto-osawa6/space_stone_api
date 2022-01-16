class CreateReturnCommentThreads < ActiveRecord::Migration[6.1]
  def change
    create_table :return_comment_threads do |t|
      t.references :comment_thread, null: false, foreign_key: true
      t.references :user, null: false,foreign_key: true
      t.text :comment,size: :long
      t.timestamps
    end
  end
end
