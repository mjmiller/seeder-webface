class ThSequence < ActiveRecord::Base
    attr_accessible :th_part_of_speech_id, :th_sort_type_direction_id,
      :th_mod_info_id
    self.table_name = 'th_sequence'
    self.primary_key = :th_sequence_id

    has_many :th_entries, :class_name => 'ThEntry'    
    has_many :th_entry_sequences, :class_name => 'ThEntrySequence'    
    has_many :th_members, :class_name => 'ThMember'    
    belongs_to :th_sort_type_direction, :class_name => 'ThSortTypeDirection', :foreign_key => :th_sort_type_direction_id    
    belongs_to :th_mod_info, :class_name => 'ThModInfo', :foreign_key => :th_mod_info_id    
end
