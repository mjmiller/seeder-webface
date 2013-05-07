class ThThesortu < ActiveRecord::Base
  attr_accessible :th_thesortus_parent_id, :th_domain_id

    self.primary_key = :th_thesortus_id

    belongs_to :th_thesortu, :class_name => 'ThThesortu', :foreign_key => :th_thesortus_parent_id    
    belongs_to :th_domain, :class_name => 'ThDomain', :foreign_key => :th_domain_id    
    belongs_to :th_mod_info, :class_name => 'ThModInfo', :foreign_key => :th_mod_info_id    
    has_many :th_thesortus_entries, :class_name => 'ThThesortusEntry'    
end
