class ThDataType < ActiveRecord::Base
  attr_accessible :description, :name
    self.table_name = 'th_data_type'
    self.primary_key = :th_data_type_id
end
