class CreateSeederStatuses < ActiveRecord::Migration
  def change
    create_table :seeder_statuses do |t|
      t.integer :pos
      t.integer :group_num
      t.integer :offset

      t.timestamps
    end
  end
end
