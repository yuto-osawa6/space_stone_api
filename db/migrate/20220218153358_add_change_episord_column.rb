class AddChangeEpisordColumn < ActiveRecord::Migration[6.1]
  def change
    add_column :episords, :release_date, :datetime
    change_column :episords,:time,:time
  end
end
