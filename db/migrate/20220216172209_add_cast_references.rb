class AddCastReferences < ActiveRecord::Migration[6.1]
  def change
    add_reference :characters,:products
    add_reference :characters,:casts
  end
end
