class ChangeEpisordTitle < ActiveRecord::Migration[6.1]
  def change
    change_column :episords, :title, :text
  end
end
