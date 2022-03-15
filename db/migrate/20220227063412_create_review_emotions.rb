class CreateReviewEmotions < ActiveRecord::Migration[6.1]
  def change
    create_table :review_emotions do |t|
      t.references :review, null: false,foreign_key: true
      t.references :emotion,null: false,foreign_key: true
      t.references :product,null: false,foreign_key: true
      t.references :user,null: false,foreign_key: true
      t.references :episord,foreign_key: true
      t.timestamps
    end
  end
end
