class ThThesortusEntry < ActiveRecord::Base
  attr_accessible :th_thesortus_id, :th_entry_id
    self.table_name = 'th_thesortus_entry'
    self.primary_key = :th_thesortus_entry_id

    belongs_to :th_thesortu, :class_name => 'ThThesortu', :foreign_key => :th_thesortus_id    
    belongs_to :th_entry, :class_name => 'ThEntry', :foreign_key => :th_entry_id    
end
