class AddAntonymsSequencedToSynsetT2Maps < ActiveRecord::Migration
  def change
    add_column :synset_t2_maps, :antonyms_sequenced, :boolean
  end
end
