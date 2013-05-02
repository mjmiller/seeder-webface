class AddEntryCreatedToSynsetT2Maps < ActiveRecord::Migration
  def change
    add_column :synset_t2_maps, :entry_created, :boolean
  end
end
