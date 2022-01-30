class CreateAcsessReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :acsess_reviews do |t|
      t.references :review, null: false, foreign_key: true
      t.integer :count,default: 0
      t.datetime :date
      t.timestamps
    end
  end
end
