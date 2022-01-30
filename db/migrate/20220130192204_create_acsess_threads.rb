class CreateAcsessThreads < ActiveRecord::Migration[6.1]
  def change
    create_table :acsess_threads do |t|
      t.references :thered, null: false, foreign_key: true
      t.integer :count,default: 0
      t.datetime :date
      t.timestamps
    end
  end
end
