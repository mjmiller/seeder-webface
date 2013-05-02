class AddThSequenceIdToSynsetT2Maps < ActiveRecord::Migration
  def change
    add_column :synset_t2_maps, :th_sequence_id, :integer
  end
end
