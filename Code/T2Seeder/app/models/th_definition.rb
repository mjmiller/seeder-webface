class ThDefinition < ActiveRecord::Base
    attr_accessible :definition, :th_mod_info_id, :th_part_of_speech_id
    self.table_name = 'th_definition'
    self.primary_key = :th_definition_id

    belongs_to :th_mod_info, :class_name => 'ThModInfo', :foreign_key => :th_mod_info_id    
    has_many :th_examples, :class_name => 'ThExample'    
    has_many :th_phrase_definitions, :class_name => 'ThPhraseDefinition'    
end
