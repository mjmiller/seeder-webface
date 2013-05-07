class ThSourceType < ActiveRecord::Base
    attr_accessible :name, :description
    self.table_name = 'th_source_type'
    self.primary_key = :th_source_type_id
    attr_accessible :name, :description

    has_many :th_sources, :class_name => 'ThSource'    
end
