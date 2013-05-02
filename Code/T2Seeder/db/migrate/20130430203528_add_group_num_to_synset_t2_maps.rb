class AddGroupNumToSynsetT2Maps < ActiveRecord::Migration
  def change
    add_column :synset_t2_maps, :group_num, :integer, :default => 0
  end
end
