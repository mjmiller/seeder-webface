class CreateSimilarPhrases < ActiveRecord::Migration
  def change
    create_table :similar_phrases do |t|
      t.integer :synset1_id
      t.integer :synset2_id

      t.timestamps
    end
  end
end
