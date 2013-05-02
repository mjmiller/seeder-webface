#  © Copyright 2013 Groove Unlimited, LLC - All Rights Reserved.
#  Unauthorized copying of this file via any medium is strictly prohibited. 
#  Content herein may be proprietary and/or confidential.

require 'wordnet'
require 'linguistics'
require_relative '../seedhandler'
load 'app/t2seeder.rb'
require 'logger'
#require '../utils/wnt2dictionary'

class Synset < WordNet::Synset

  def initialize
    log=Logger.new(STDOUT)
    log.level = Logger::INFO 
  end #initialize

def self.findAntonyms(sset) 
        antonyms = []
        #In addition to this primary synset, lets find its antonym synset.
        #This is needed for default seeding
        sql="SELECT `synsetid` FROM `synsets` WHERE (`synsetid` IN (SELECT `synset2id`"\
          " FROM `lexlinks` WHERE ((`lexlinks`.`synset1id` ="+
          sset.synsetid.to_s+") AND (`linkid` = "+
          WordNet::Synset.linktypes[:antonym][:id].to_s+"))))"
        res =  WNConn.query(sql)
        res.each do |row|
          log.warn "Antonym (synset) #: " + WordNet::Synset[row].synsetid.to_s + " found" 
          antonyms.push(WordNet::Synset[row])
        end
        antonyms
end

def self.offsetter(off, lim) 
        synsets = []
        sql="SELECT `synsetid` FROM `synsets` LIMIT "+lim.to_s+" OFFSET "+off.to_s
        #TODO: Understand why the above works, whereas
        ###### sql="SELECT * FROM `synsets` LIMIT "+lim.to_s+" OFFSET "+off.to_s doesn't
        res =  WNConn.query(sql)
        res.each do |row|
          synsets.push(WordNet::Synset[row])
        end
        return synsets
end

 #############################################
 #############################################
 #############################################
 #############################################
 #IS ANYTHING BELOW HERE USED? IF NOT REMOVE.#
 #############################################
  
##  OBJTYPE = ObjType.find_by_name('synset').id
##  private_constant :OBJTYPE 
##
##  def initialize
##
##  end
##
##  def convert2T2components
##    #
##    # If this synset has not been converted into a set of T2 table entries, do so.
##    #
##
##    unless ObjProcessStatus.find_by_source_id_and_obj_type_id(self.synsetid, OBJTYPE)
##      # Add this synset to the ObjProcessStatus table
##      ObjProcessStatus.create(:obj_type_id => OBJTYPE, :source_id => self.synsetid, :process_status_id => IN_PROGRESS )
##      
##      synset.words.each do |word|
##        # First find the word in T2's database, or create a new entry if it isn't in there.
##        th_phrase = ThPhrase.find_or_create_by_lemma(word.lemma)
##        # A ThPhraseDefinition id is needed so create one.  Note that even if
##        # this word had been in T2's database associated with other ThPhraseDefinitions,
##        # a new ThPhraseDefinition is required for this definition.
##        # Create a ThDefinition entry
##        th_def = ThDefinition.create(:definition => synset.definition, 
##                                   :th_part_of_speech_id => synset.pos, 
##                                   :th_mod_info_id => MyDModInfo.id)
##        # And now a ThPhraseDefinition
##        th_phrase_def = ThPhraseDefinition.create(:th_phrase_id => th_phrase.id,
##                                                  :th_definition_id => th_def.id,
##                                                  :th_mod_info_id => MyDModInfo.id)
##
##      end
##    end
##  end
##
##  # *********************************************************
##
##  def do_your_stuff
##    size = 5
##    WordNet::Synset.nouns.limit(size).each do |sset|
##      shandler = SeedHandler.new
##      phrdefs = shandler.sowPhrasesFromLex(sset.words, sset.words.size)
##      puts phrdefs
##      self.build_sequence(sset, phrdefs)
##    end
##  end
##
##  def build_sequence(sset, phrdefids)
##    unless phrdefids==nil || sset==nil
##      #create the sequence for this synset's words given their phrase_defs.
##      thisSeq = ThSequence.new(:th_part_of_speech_id => 
##                               ThPartOfSpeech.where{name.eq Wnt2dictionary.translate_into_t2(sset.pos)}.first.th_part_of_speech_id, 
##                               :th_sort_type_direction_id => 
##                               MyDSortTypeDirection.id, :th_mod_info_id => MyDModInfo.id)
##      thisSeq.save
##      #Add members to the above sequence
##      phrdefids.each do |id|
##        thisMember = ThMember.create(:th_sequence_id => thisSeq.id, :th_phrase_definition_id => id, :ordinality => 1, :th_mod_info_id => MyDModInfo.id)
##
##      end
##    end
##  end
  end
