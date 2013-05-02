class AddPrimariesSequencedToSynsetT2Maps < ActiveRecord::Migration
  def change
    add_column :synset_t2_maps, :primaries_sequenced, :boolean
  end
end
