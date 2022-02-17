class Addocupation < ActiveRecord::Migration[6.1]
  def change
    add_reference :occupations,:products,null: :false
    add_reference :occupations,:staffs,null: false
  end
end
