class ThExample < ActiveRecord::Base
    self.table_name = 'th_example'
    self.primary_key = :th_example_id

    belongs_to :th_definition, :class_name => 'ThDefinition', :foreign_key => :th_definition_id    
    belongs_to :th_mod_info, :class_name => 'ThModInfo', :foreign_key => :th_mod_info_id    
end
