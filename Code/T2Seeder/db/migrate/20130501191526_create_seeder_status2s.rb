class CreateSeederStatus2s < ActiveRecord::Migration
  def change
    create_table :seeder_status2s do |t|
      t.integer :pos
      t.integer :group_num
      t.integer :offset

      t.timestamps
    end
  end
end
