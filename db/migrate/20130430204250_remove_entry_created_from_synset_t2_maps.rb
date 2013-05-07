class RemoveEntryCreatedFromSynsetT2Maps < ActiveRecord::Migration
  def up
    remove_column :synset_t2_maps, :entry_created
  end

  def down
    add_column :synset_t2_maps, :entry_created, :boolean
  end
end
