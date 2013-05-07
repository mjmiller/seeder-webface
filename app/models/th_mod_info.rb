class ThModInfo < ActiveRecord::Base
  attr_accessible :th_source_id, :th_editor_action_id
    self.table_name = 'th_mod_info'
    self.primary_key = :th_mod_info_id

    has_many :th_definitions, :class_name => 'ThDefinition'    
    has_many :th_entries, :class_name => 'ThEntry'    
    has_many :th_entry_labels, :class_name => 'ThEntryLabel'    
    has_many :th_examples, :class_name => 'ThExample'    
    has_many :th_members, :class_name => 'ThMember'    
    has_many :th_metadata_keys, :class_name => 'ThMetadataKey'    
    belongs_to :th_source, :class_name => 'ThSource', :foreign_key => :th_source_id    
    belongs_to :th_editor_action, :class_name => 'ThEditorAction', :foreign_key => :th_editor_action_id    
    has_many :th_phrases, :class_name => 'ThPhrase'    
    has_many :th_phrase_definitions, :class_name => 'ThPhraseDefinition'    
    has_many :th_sequences, :class_name => 'ThSequence'    
    has_many :th_sort_directions, :class_name => 'ThSortDirection'    
    has_many :th_sort_types, :class_name => 'ThSortType'    
    has_many :th_thesortus, :class_name => 'ThThesortu'    
end
