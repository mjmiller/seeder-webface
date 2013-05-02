class ThEditorAction < ActiveRecord::Base
    attr_accessible :name, :description
    self.table_name = 'th_editor_action'
    self.primary_key = :th_editor_action_id

    has_many :th_mod_infos, :class_name => 'ThModInfo'    
end
