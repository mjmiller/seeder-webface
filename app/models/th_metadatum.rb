class ThMetadatum < ActiveRecord::Base
    attr_accessible :th_metadata_key_id, :value, :th_phrase_definition_id

    self.primary_key = :th_metadata_id

    belongs_to :th_metadata_key, :class_name => 'ThMetadataKey', :foreign_key => :th_metadata_key_id    
    belongs_to :th_phrase_definition, :class_name => 'ThPhraseDefinition', :foreign_key => :th_phrase_definition_id    
end
