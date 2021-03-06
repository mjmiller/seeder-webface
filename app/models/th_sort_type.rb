class ThSortType < ActiveRecord::Base
    attr_accessible :label, :description, :th_mod_info_id, :th_metadata_key_id
    self.table_name = 'th_sort_type'
    self.primary_key = :th_sort_type_id

    belongs_to :th_mod_info, :class_name => 'ThModInfo', :foreign_key => :th_mod_info_id    
    belongs_to :th_metadata_key, :class_name => 'ThMetadataKey', :foreign_key => :th_metadata_key_id    
    has_many :th_sort_type_directions, :class_name => 'ThSortTypeDirection'    
end
