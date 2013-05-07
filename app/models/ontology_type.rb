class OntologyType < ActiveRecord::Base
  attr_accessible :category, :name, :ontologyTypeParentId
end
