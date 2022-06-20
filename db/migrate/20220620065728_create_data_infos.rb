class CreateDataInfos < ActiveRecord::Migration[6.1]
  def change
    create_table :data_infos do |t|
      t.string :info
      t.timestamps
    end
  end
end
