class CreateReturnReturnCommentThreads < ActiveRecord::Migration[6.1]
  def change
    create_table :return_return_comment_threads do |t|
      t.references :return_comment_thread, null: false, foreign_key: true
      t.references :return_return_thread, foreign_key: { to_table: :return_comment_threads }
      t.timestamps
    end
  end
end
