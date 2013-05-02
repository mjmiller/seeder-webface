class AddSimilarsSequencedToSynsetT2Maps < ActiveRecord::Migration
  def change
    add_column :synset_t2_maps, :similars_sequenced, :boolean
  end
end
