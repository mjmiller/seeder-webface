class ThMetadataKey < ActiveRecord::Base
  attr_accessible :key, :description, :th_mod_info_id, :th_data_type_id
    self.table_name = 'th_metadata_key'
    self.primary_key = :th_metadata_key_id

    has_many :th_metadata, :class_name => 'ThMetadatum'    
    belongs_to :th_mod_info, :class_name => 'ThModInfo', :foreign_key => :th_mod_info_id    
    has_many :th_sort_types, :class_name => 'ThSortType'    
end
