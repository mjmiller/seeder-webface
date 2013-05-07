class CreateObjProcessStatuses < ActiveRecord::Migration
  def change
    create_table :obj_process_statuses do |t|
      t.integer :obj_type_id
      t.integer :source_id
      t.integer :process_status_id

      t.timestamps
    end
  end
end
