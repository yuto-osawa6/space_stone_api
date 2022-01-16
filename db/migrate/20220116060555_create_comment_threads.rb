class CreateCommentThreads < ActiveRecord::Migration[6.1]
  def change
    create_table :comment_threads do |t|
      t.references :thered, null: false, foreign_key: true
      t.references :user, null: false,foreign_key: true
      t.text :comment,size: :long
      t.timestamps
    end
  end
end
