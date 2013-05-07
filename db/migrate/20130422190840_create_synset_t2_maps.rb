class CreateSynsetT2Maps < ActiveRecord::Migration
  def change
    create_table :synset_t2_maps do |t|
      t.integer :synset_id
      t.integer :phrase_def_id

      t.timestamps
    end
  end
end
