class CreateTiers < ActiveRecord::Migration[6.1]
  def change
    create_table :tiers do |t|
      t.references :product,null: false
      # t.refereces :group
      t.references :user,null: false
      t.integer :tier
      t.timestamps
    end
  end
end
