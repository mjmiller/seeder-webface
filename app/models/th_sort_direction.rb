class ThSortDirection < ActiveRecord::Base
    attr_accessible :label, :description, :th_mod_info_id
    self.table_name = 'th_sort_direction'
    self.primary_key = :th_sort_direction_id

    belongs_to :th_mod_info, :class_name => 'ThModInfo', :foreign_key => :th_mod_info_id    
    has_many :th_sort_type_directions, :class_name => 'ThSortTypeDirection'    
    has_many :th_sort_type_directions, :class_name => 'ThSortTypeDirection'    
end
