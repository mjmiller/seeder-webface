class Ontology < ActiveRecord::Base
  validates :name, :uniqueness => {:scope => :version}

  belongs_to :ontology_type
   attr_accessible :description, :location, :name, :ontology_type, :version, :classname 
   before_save :init_attributes 




# def to_param
#      "#{id}-#{name.parameterize}"
#      end
# 



  def init_attributes 
     self.attributes.keys.each do |key|
      if APP_CONFIG["ontoltoolkit"]["ontology"].key?(key)
         self[key.to_sym] = APP_CONFIG["ontoltoolkit"]["ontology"][key]
      end
     end
   end


    
  
end
