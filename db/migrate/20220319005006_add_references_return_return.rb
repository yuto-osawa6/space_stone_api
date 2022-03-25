class AddReferencesReturnReturn < ActiveRecord::Migration[6.1]
  def change
    # add_reference :return_comment_reviews,:return_user, foreign_key: { to_table: :users }
    # add_reference :return_comment_threads,:return_user, foreign_key: { to_table: :users }
   
    add_column :return_comment_reviews, :reply, :boolean, default: false
    add_column :return_comment_threads, :reply, :boolean, default: false
  end
end
