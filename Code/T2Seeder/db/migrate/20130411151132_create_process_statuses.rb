class CreateProcessStatuses < ActiveRecord::Migration
  def change
    create_table :process_statuses do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
