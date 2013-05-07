class ThEntry < ActiveRecord::Base
  attr_accessible  :th_sequence_default_id, :th_mod_info_id, :title, :description
    self.table_name = 'th_entry'
    self.primary_key = :th_entry_id

    belongs_to :th_mod_info, :class_name => 'ThModInfo', :foreign_key => :th_mod_info_id    
    belongs_to :th_sequence, :class_name => 'ThSequence', :foreign_key => :th_sequence_default_id    
    has_many :th_entry_labels, :class_name => 'ThEntryLabel'    
    has_many :th_entry_sequences, :class_name => 'ThEntrySequence'    
    has_many :th_thesortus_entries, :class_name => 'ThThesortusEntry'    
end
