class AddStaffProductstoOcupationsId < ActiveRecord::Migration[6.1]
  def change
    add_reference :staff_products,:occupations
  end
end
