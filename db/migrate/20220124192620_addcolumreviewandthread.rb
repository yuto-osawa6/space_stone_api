class Addcolumreviewandthread < ActiveRecord::Migration[6.1]
  def change
    add_reference :reviews, :episord
    add_reference :thereds, :episord
  end
end
