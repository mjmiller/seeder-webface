#  © Copyright 2013 Groove Unlimited, LLC - All Rights Reserved.
#  Unauthorized copying of this file via any medium is strictly prohibited. 
#  Content herein may be proprietary and/or confidential.

require_relative '../t2seeder'
require 'active_model'



class ColorMngr 
  include  ActiveModel
 attr_accessor :words 
## Colorset = ["blue","red","orange","yellow","violet","indigo","purple",
##  "green","black","white","tan","crimson","aquamarine","salmon"]
 Colorset = ["entity","physical entity", "abstract entity", "thing", "object", "unit", "congener", "animate thing", "being", "benthos"]
  def initialize #automatically invoked when Colors object is created with Colors.new
    @words = []
    Colorset.each do |color|

      ##@words.insert(0,Lexs[color,'color'].words.first)
      setofwords = Lexs[color].words.map(&:lemma)
      i =0
      setofwords.each do |element|
        puts '***' + element + '***'
      @words.insert(0,Lexs[element].words[i])
      i +=1
      end
    end

  end
end
