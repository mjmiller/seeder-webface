class ThDomain < ActiveRecord::Base
    attr_accessible :name, :description
    self.table_name = 'th_domain'
    self.primary_key = :th_domain_id

    has_many :th_thesortus, :class_name => 'ThThesortu'    
end
