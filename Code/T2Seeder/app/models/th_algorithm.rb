class ThAlgorithm < ActiveRecord::Base
  self.table_name = 'th_algorithm'
  self.primary_key = :th_algorithm_id
  attr_accessible :description, :name

  has_many :th_sources, :class_name => 'ThSource'    
  before_save :init_attributes 

  def init_attributes 
    #TODO: Make init_attributes DRY
    self.attributes.keys.each do |key|
      if APP_CONFIG["algorithm"].key?(key)
        self[key.to_sym] = APP_CONFIG["algorithm"][key]
      end
    end
  end
end
