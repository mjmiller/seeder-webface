
#  © Copyright 2013 Groove Unlimited, LLC - All Rights Reserved.
#  Unauthorized copying of this file via any medium is strictly prohibited. 
#  Content herein may be proprietary and/or confidential.

require_relative '../t2seeder'

class Wnt2dictionary
  def self.translate_into_t2(term)
    case term
    when 'n', :n, 'noun', :noun
      'noun'
    when 'v', :v, 'verb', :verb
      'verb'
    when 'a',:a, 'adj', 'adj.', 'adjective', :adjective, 's', :s, 'adjective satellite', :adjective_satellite
      'adjective'
    when :r, 'r', :adverb, 'adverb'
      'adverb'
    else
      nil 
    end
  end

  def self.translate_into_wn(term)
    case term
    when 'adjective', 'adj.'
      :a 
    when 'adverb', 'adv.'
      :r
    when 'noun'
      :n
    when 'verb'
      :v
    else
      nil
    end

  end
end

