class ThPhraseDefinition < ActiveRecord::Base
    attr_accessible :th_phrase_id, :th_definition_id, :th_mod_info_id
    self.table_name = 'th_phrase_definition'
    self.primary_key = :th_phrase_definition_id

    has_many :th_members, :class_name => 'ThMember'    
    has_many :th_metadata, :class_name => 'ThMetadatum'    
    has_many :synset_t2_maps, :class_name => 'SynsetT2Map' 
    belongs_to :th_phrase, :class_name => 'ThPhrase', :foreign_key => :th_phrase_id    
    belongs_to :th_definition, :class_name => 'ThDefinition', :foreign_key => :th_definition_id    
    belongs_to :th_mod_info, :class_name => 'ThModInfo', :foreign_key => :th_mod_info_id    
end
