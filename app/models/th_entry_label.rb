class ThEntryLabel < ActiveRecord::Base
    attr_accessible :name, :description, :th_mod_info_id, :th_entry_id
    self.table_name = 'th_entry_label'
    self.primary_key = :th_entry_label_id

    belongs_to :th_entry, :class_name => 'ThEntry', :foreign_key => :th_entry_id    
    belongs_to :th_mod_info, :class_name => 'ThModInfo', :foreign_key => :th_mod_info_id    
end
