#  © Copyright 2013 Groove Unlimited, LLC - All Rights Reserved.
#  Unauthorized copying of this file via any medium is strictly prohibited. 
#  Content herein may be proprietary and/or confidential.
#
class ThUser < ActiveRecord::Base
  #Because standard ruby naming conventions have been overidden we need to tell ThUser which table it corresponds to and that table's primary key.
  self.table_name = 'th_user'
  self.primary_key = :th_userId
 #validates :username, :uniqueness => true 
  attr_accessible :cms_usr_id
  before_save :init_attributes 

  def init_attributes 
     #TODO: Make init_attributes DRY
     #TODO: Comment init_attributes
     puts "hello"
     self.attributes.keys.each do |key|
        puts key
      if APP_CONFIG["user"].key?(key)
         puts "true"
         puts key.to_sym
         puts APP_CONFIG["user"][key]
         puts "ready"
         self[key.to_sym] = APP_CONFIG["user"][key]
      end
     end
   end
end
