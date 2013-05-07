class ThSource < ActiveRecord::Base
    attr_accessible :th_source_type_id, :th_user_id, :th_algorithm_id, :external_ref_id
    self.table_name = 'th_source'
    self.primary_key = :th_source_id

    has_many :th_mod_infos, :class_name => 'ThModInfo'    
    belongs_to :th_user, :class_name => 'ThUser', :foreign_key => :th_user_id    
    belongs_to :th_source_type, :class_name => 'ThSourceType', :foreign_key => :th_source_type_id    
    belongs_to :th_algorithm, :class_name => 'ThAlgorithm', :foreign_key => :th_algorithm_id    
end
