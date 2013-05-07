class ThPhrase < ActiveRecord::Base
    attr_accessible :lemma 
    self.table_name = 'th_phrase'
    self.primary_key = :th_phrase_id

 #   belongs_to :th_mod_info, :class_name => 'ThModInfo', :foreign_key => :th_mod_info_id    
    has_many :th_phrase_definitions, :class_name => 'ThPhraseDefinition'    
end
