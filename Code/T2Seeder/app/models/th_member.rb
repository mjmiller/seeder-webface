class ThMember < ActiveRecord::Base
  attr_accessible :th_sequence_id, :th_phrase_definition_id, :ordinality, :th_mod_info_id
    self.table_name = 'th_member'
    self.primary_key = :th_member_id

    belongs_to :th_sequence, :class_name => 'ThSequence', :foreign_key => :th_sequence_id    
    belongs_to :th_phrase_definition, :class_name => 'ThPhraseDefinition', :foreign_key => :th_phrase_definition_id    
    belongs_to :th_mod_info, :class_name => 'ThModInfo', :foreign_key => :th_mod_info_id    
end
