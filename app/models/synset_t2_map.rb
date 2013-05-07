class SynsetT2Map < ActiveRecord::Base
  attr_accessible :th_phrase_definition_id, :synset_id, :th_sequence_id, :primaries_sequenced, :similars_sequenced, :antonyms_sequenced, :group_num
  belongs_to :th_phrase_definition, :class_name => 'ThPhraseDefinition', :foreign_key => :th_phrase_definition_id    

end
