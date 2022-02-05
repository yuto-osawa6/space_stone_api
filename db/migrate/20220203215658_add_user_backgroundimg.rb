class AddUserBackgroundimg < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :background_image, :text,size: :long
  end
end
