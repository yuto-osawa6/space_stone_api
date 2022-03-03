class AddScoreValues < ActiveRecord::Migration[6.1]
  def change
    add_column :scores ,:music, :integer
    add_column :scores ,:character, :integer
    add_column :scores ,:animation, :integer
    add_column :scores ,:story, :integer
    add_column :scores ,:performance, :integer
    add_column :scores ,:all, :integer


  end
end
