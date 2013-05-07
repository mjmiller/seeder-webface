class CreateObjTypes < ActiveRecord::Migration
  def change
    create_table :obj_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
