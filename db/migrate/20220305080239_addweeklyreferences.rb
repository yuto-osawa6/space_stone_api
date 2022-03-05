class Addweeklyreferences < ActiveRecord::Migration[6.1]
  def change
    add_reference :weeklyrankings,:week,null: :false
  end
end
