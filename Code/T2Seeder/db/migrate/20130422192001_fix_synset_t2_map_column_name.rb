class FixSynsetT2MapColumnName < ActiveRecord::Migration
  def change
    rename_column :synset_t2_maps, :phrase_def_id, :th_phrase_definition_id
  end
end
