#  © Copyright 2013 Groove Unlimited, LLC - All Rights Reserved.
#  Unauthorized copying of this file via any medium is strictly prohibited. 
#  Content herein may be proprietary and/or confidential.


# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

tables = [
  'th_thesortus',
  'th_domain',
#  'th_part_of_speech',
#  'obj_type',
#  'process_status'
   ]
tables.each do |table|
#ActiveRecord::Base.connection.table
      ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
end

##File.open('db/partsofspeech.txt', 'r') do |pos|
##  while ((line = pos.gets) != nil)
##    unless line.starts_with?('#')
##      puts    /'(?<naym>.+)'.+'(?<abreviation>.+)'/.match(line)[:abreviation]
##      ThPartOfSpeech.create!(:name => $1, :abbr => $2)
##    end
##  end
##end

puts "HERE"

File.open('db/domains.txt', 'r') do |domain|
  while ((line = domain.gets) != nil)
    unless line.starts_with?('#')
      puts    /'(?<naym>.+)'.+'(?<description>.+)'/.match(line)[:description]
      ThDomain.create!(:name => $1, :description => $2)
    end
  end
end

puts "THERE"

File.open('db/thesorti.txt', 'r') do |thesortus|
  while ((line = thesortus.gets) != nil)
    unless line.starts_with?('#')
      puts    /'(?<parentid>.+).+'(?<domainid>.+)'/.match(line)[:domainid]
      ThThesortu.create!(:th_thesortus_parent_id=> $1, :th_domain_id => $2)
    end
  end
end
puts "Everywhere"
## File.open('db/processstatuses.txt', 'r') do |status|
##   while ((line = status.gets) != nil)
##     unless line.starts_with?('#')
##       puts    /'(?<naym>.+)'.+'(?<description>.+)'/.match(line)[:description]
##       ProcessStatus.create!(:name => $1, :description => $2)
##     end
##   end
## end
## 
## File.open('db/objecttypes.txt', 'r') do |type|
##   while ((line = type.gets) != nil)
##     unless line.starts_with?('#')
##       puts    /'(?<naym>.+)'.+'(?<description>.+)'/.match(line)[:description]
##       ObjType.create!(:name => $1, :description => $2)
##     end
##   end
## end


