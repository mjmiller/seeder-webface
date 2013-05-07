class ThSortTypeDirection < ActiveRecord::Base
  attr_accessible :th_sort_type_id, :th_sort_direction_asc_id, :th_sort_direction_desc_id
    self.table_name = 'th_sort_type_direction'
    self.primary_key = :th_sort_type_direction_id

    has_many :th_sequences, :class_name => 'ThSequence'    
    belongs_to :th_sort_type, :class_name => 'ThSortType', :foreign_key => :th_sort_type_id    
    belongs_to :th_sort_direction, :class_name => 'ThSortDirection', :foreign_key => :th_sort_direction_asc_id    
    belongs_to :th_sort_direction, :class_name => 'ThSortDirection', :foreign_key => :th_sort_direction_desc_id    
end
