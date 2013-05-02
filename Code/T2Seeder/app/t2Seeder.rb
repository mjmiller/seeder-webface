#  © Copyright 2013 Groove Unlimited, LLC - All Rights Reserved.
#  Unauthorized copying of this file via any medium is strictly prohibited. 
#  Content herein may be proprietary and/or confidential.

require 'wordnet'
require 'linguistics'
require_relative 'seedhandler'

class T2seeder
  #
  # The primary function of this app is to seed Thesortus T2 with data from WordNet 3,
  # and this is the entry point for doing so.
  # 
  #
  def self.perform(step, synsets = [], groupnum = UNSPECIFIED_2)
    # Called with a step name constant 
    #
    shandler = SeedHandler.new
    case step 
    when :GATHER_SSETS
      return self.gatherSynsets()
    when :CONVERT_SSETS
      shandler.convert2T2components(synsets, groupnum)
      return
    when :SEQ_SSETS
      log.unknown "Begin create sequences prep"
      synsets = Array.new
      sequenceables = 
        SynsetT2Map.where{
        (th_phrase_definition_id > 0) &
        (th_sequence_id  == nil ) &
        (group_num == groupnum)
      }
      ##  SynsetT2Map.where("synset_t2_maps.th_phrase_definition_id IS NOT NULL") &
      ##  SynsetT2Map.where("synset_t2_maps.th_sequence_id IS  NULL")
      sequenceables.each do |seq|
        synsets.push(WordNet::Synset[seq.synset_id])
      end
      log.unknown "End create sequences prep\n"
      shandler.sequence(synsets.uniq)
      return 
    when :SEQ_PRIM_MEMBRS
      #Add primary sequence members for each  synset's sequence.  
      #Primary members are just those words/phrases in the synset.
      log.unknown "Begin primary membership prep"
      synsets=Array.new
      primary_sequenceables =
        SynsetT2Map.where("synset_t2_maps.th_phrase_definition_id IS NOT NULL") &
        SynsetT2Map.where("synset_t2_maps.th_sequence_id IS NOT NULL") &
        SynsetT2Map.where("synset_t2_maps.primaries_sequenced IS FALSE")
      primary_sequenceables.each do |seq|
        synsets.push(WordNet::Synset[seq.synset_id])
      end
      log.unknown "End primary membership prep\n"
      shandler.sequencePrimaries(synsets.uniq)
      return 
    when :SEQ_SIM_MEMBRS
      #Add similars sequence members for each synset.
      #Similars are those synsets' words/phrases found using WordNet::Synset#similar_words
      log.unknown "Begin similars membership prep"
      synsets=Array.new
      similars_sequenceables =
        SynsetT2Map.where{
        (th_phrase_definition_id > 0) &
        (th_sequence_id > 0 ) &
        (group_num == groupnum) &
        (similars_sequenced == FALSE)
      }
      ##SynsetT2Map.where("synset_t2_maps.th_phrase_definition_id IS NOT NULL") &
      ##SynsetT2Map.where("synset_t2_maps.th_sequence_id IS NOT NULL") &
      ##SynsetT2Map.where("synset_t2_maps.similars_sequenced IS FALSE") 
      similars_sequenceables.each do |seq|
        synsets.push(WordNet::Synset[seq.synset_id])
      end
        puts "ready for sim synsetting =>>> "
          synsets.each do |seq|
          puts seq
          end
      log.unknown "End similars membership prep\n"
      #Exactly one of each applicable synset is passed to sequenceSimilars with synsets.uniq
      shandler.sequenceSimilars(synsets.uniq)
      return 
    when :SEQ_ANT_MEMBRS
      #Add antonyms sequence members for each synset.
      log.unknown "Begin antonym membership prep"
      synsets=Array.new
      antonyms_sequenceables =
        SynsetT2Map.where{
        (th_phrase_definition_id > 0) &
        (th_sequence_id > 0 ) &
        (group_num == groupnum) &
        (antonyms_sequenced == FALSE)
      }
        ##SynsetT2Map.where("synset_t2_maps.th_phrase_definition_id IS NOT NULL") &
        ##SynsetT2Map.where("synset_t2_maps.th_sequence_id IS NOT NULL") &
        ##SynsetT2Map.where("synset_t2_maps.antonyms_sequenced IS FALSE") 
      antonyms_sequenceables.each do |seq|
        synsets.push(WordNet::Synset[seq.synset_id])
      end
      #Exactly one of each applicable synset is passed to sequenceSimilars with synsets.uniq
      log.unknown "End antonym membership prep\n"
      shandler.sequenceAntonyms(synsets.uniq)
      return
    else
      log.warn "UNKNOWN STEP NAME, PLEASE TRY AGAIN."
    end

  end


  def self.gatherSynsets(lextypes=['nouns','verbs','adjectives','adverbs'], lim=30, offset=0) 
    #lim: limit used for development for when I don't want to retrieve ALL synsets!
    puts "begin gathering"
    #lextypes=['adjectives', 'adverbs', 'nouns', 'verbs'] 
    #lextypes=['nouns'] 
    #lextypes=[ 'adverbs', 'adjectives'] 
    synsets=Array.new
    lextypes.each do |lextype|
      #get the first 'lim' number of synsets of type lextype, starting at offset
      WordNet::Synset.send(lextype).limit(lim,offset).each do |sset| 
     # WordNet::Synset.send(lextype).limit(lim).each do |sset| 
        synsets.push(sset)
      end
    end
    return synsets 
    :ok
  end

  def self.start(lastprocessedsset=0, #lastprocessed: the offset into lextype of the last synset(s) processed
                 lastgroupnum=0,
                 groupsize=15,
                 numofgroups=3,
                 partsofspeech=['verbs','nouns','adjectives','adverbs','adjective_satellites'])
    i=1
    groupnum = lastgroupnum+1 
    until i > numofgroups do
      offset=lastprocessedsset+(i-1)*groupsize
      puts "offset: "+offset.to_s+" groupnum: "+groupnum.to_s
      ssets = (self.gatherSynsets(partsofspeech,groupsize, offset))
      self.perform(:CONVERT_SSETS, ssets, groupnum)
      self.perform(:SEQ_SSETS,[],groupnum)
      self.perform(:SEQ_PRIM_MEMBRS,[],groupnum)
      self.perform(:SEQ_SIM_MEMBRS,[],groupnum)
      self.perform(:SEQ_ANT_MEMBRS,[],groupnum)
      i +=1
      groupnum += 1
    end
  end

end # Class T2seeder

