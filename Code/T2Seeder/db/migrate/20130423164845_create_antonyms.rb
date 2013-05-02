class CreateAntonyms < ActiveRecord::Migration
  def change
    create_table :antonyms do |t|
      t.integer :synset1_id
      t.integer :synset2

      t.timestamps
    end
  end
end
