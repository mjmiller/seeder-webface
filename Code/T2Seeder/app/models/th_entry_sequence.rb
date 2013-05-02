class ThEntrySequence < ActiveRecord::Base
  attr_accessible :th_entry_id, :th_sequence_id
    self.table_name = 'th_entry_sequence'
    self.primary_key = :th_entry_sequence_id

    belongs_to :th_entry, :class_name => 'ThEntry', :foreign_key => :th_entry_id    
    belongs_to :th_sequence, :class_name => 'ThSequence', :foreign_key => :th_sequence_id    
end
