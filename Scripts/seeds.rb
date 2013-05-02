# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ThPartOfSpeech.delete_all
File.open('db/partsofspeech.txt', 'r') do |pos|
  while ((line = pos.gets) != nil)
    puts    /'(?<naym>.+)'.+'(?<abreviation>.+)'/.match(line)[:abreviation]
    ThPartOfSpeech.create!(:name => $1, :abbr => $2)
  end
end

