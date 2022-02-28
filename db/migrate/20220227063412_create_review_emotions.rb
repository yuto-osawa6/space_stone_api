class CreateReviewEmotions < ActiveRecord::Migration[6.1]
  def change
    create_table :review_emotions do |t|
      t.references :review, null: :false
      t.references :emotion,null: :false
      t.timestamps
    end
  end
end
