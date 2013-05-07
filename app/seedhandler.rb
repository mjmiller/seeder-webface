#  © Copyright 2013 Groove Unlimited, LLC - All Rights Reserved.
#  Unauthorized copying of this file via any medium is strictly prohibited. 
#  Content herein may be proprietary and/or confidential.


require_relative 't2seeder'
require_relative 'utils/wnt2dictionary'
require 'logger'
class SeedHandler

  #
  #TODO: Add documentation
  #
  def initialize #Automatically invoked when a SeedHandler is created with SeedHandler.new
    @myUserId = MyUser.th_userId
    @lexs = Lexs
    #The following is inconsistent with how lexs is generated.
    @words = WordNet::Word 
    @editAction = MyEditAction.th_editor_action_id
    @srcProps = SRC_Props
    log=Logger.new(STDOUT)
    log.level = Logger::INFO
  end #initialize

  #
  # Class Methods
  # 
  def self.clear(tablenames) #Utility development function to clear data from tables
    #TODO: Move to a utils class
    tablenames.each {|tname| Object.const_get(tname).delete_all}
  end

  def self.truncate(tablenames)
    #Clears records from the table(s) and resets primary key indexer to 1.
    #TODO: Move to a utils class
    tablenames.map{|table| ActiveRecord::Base.connection.execute("TRUNCATE #{table}")}
  end
  #
  # Instance Methods
  #
  def  seedSynsets(synsets)
    #
    # synsets is an enumeration of WordNet synsets, each of which comprises
    # a set of words, a definition, and a part of speech. 
    # SeedSynsets processes each synset by: extracting its words, definition, 
    # and part  of speech; creating the appropriate th_phrase, th_definition,
    # and th_phrase_definition  entries.
    #
    synsets.each do |synset|
      self.convert2T2components(synset)

    end

  end

  def convert2T2components(synsets, groupnum = UNSPECIFIED_1)
    #
    # If this synset has not yet been mapped/converted, do so. Otherwise, return.
    #

    progress = 0
    synsets.each do |synset|

      unless SynsetT2Map.find_by_synset_id(synset.synsetid)
        synset.words.each do |word|
######Console progress indicator##################              
          progress=progress+1
          if progress%9==0
            print '.'
            if progress%100==0
              print "+\n"
            end
          end
##################################################
          # Create a mapping for this (word)X(definition) pair in SynsetT2Map table. 
          # This table also tracks the synset's processing progress.
          mapping = SynsetT2Map.create(:synset_id => synset.synsetid,
                                       :group_num => groupnum)
          # Each word in the synset is converted to a ThPhrase.
          # First find the word in T2's database, or create a new entry if it isn't in there.
          th_phrase = ThPhrase.find_or_create_by_lemma(word.lemma)
          # The synset's definition is converted to a ThDefinition for this word.
          # Note that other words in this synset have the same english language definition (as a string),
          # but each gets its own entry in the ThDefinition table. This enables
          # later editorial forking of individual word's definitions.
          th_def = ThDefinition.create(:definition => synset.definition, 
                                       :th_part_of_speech_id => \
                                       #ThPartOfSpeech.find_by_name(Wnt2dictionary.translate_into_t2(synset.pos).to_sym).id, 
                                       ThPartOfSpeech.where{name.eq Wnt2dictionary.translate_into_t2(synset.pos)}.first.th_part_of_speech_id,
                                       :th_mod_info_id => MyDModInfo.id)
          # Each synset (word)X(definition) pair is converted to a ThPhraseDefinition
          th_phrase_def = ThPhraseDefinition.create(:th_phrase_id => th_phrase.id,
                                                    :th_definition_id => th_def.id,
                                                    :th_mod_info_id => MyDModInfo.id)

          # Update this synset's mapping with the proper th_phrase_definition_id. 
          mapping.update_attribute(:th_phrase_definition_id,  th_phrase_def.id)
        end
      end
    end
  end #convert2T2components

  def sequence(synsets)
    #
    #Each Wordnet synset is the basis for one or more T2 sequences. We produce those sequences here. 
    #
    progress = 0
    synsets.each do |synset|
######Console progress indicator##################              
          progress=progress+1
          if progress%9==0
            print '.'
            if progress%100==0
              print "+\n"
            end
          end
##################################################
      # Make sure synset is ready to be sequenced
      #Create a ThSequence entry for this synset and its relatives.
      sequence = ThSequence.create(:th_sort_type_direction_id => MyDSortTypeDirection.id,
                                   :th_mod_info_id => MyDModInfo.id,
                                   #:th_part_of_speech_id => ThPartOfSpeech.find_by_name(Wnt2dictionary.translate_into_t2(synset.pos)).id)
                                   :th_part_of_speech_id => ThPartOfSpeech.where{name.eq Wnt2dictionary.translate_into_t2(synset.pos)}.first.th_part_of_speech_id)
      unless (synsetmaps=SynsetT2Map.find_all_by_synset_id(synset.synsetid))==[]
        synsetmaps.each do |synmap|
          #First update the synmap with the above sequence id
          synmap.update_attribute(:th_sequence_id, sequence.th_sequence_id)

        end
        #Each sequence is the basis for a single entry so 
        #why not create the entry while we're here.
       self.createEntry(sequence, synset)
      end
    end
  end


  def createEntry(sequence, synset)
          entry = ThEntry.create(
            :th_sequence_default_id => sequence.th_sequence_id, 
            :th_mod_info_id => MyDModInfo.id,
            :title => 'Seeded sequence for words related to the synset words: ' +
            synset.words.map{ |x| x.lemma}.to_s.gsub!(/\"/,""),
            #gsub needed above because to_s adds escaped quotes (\") to words
            :description => ThPartOfSpeech.find_by_th_part_of_speech_id(sequence.th_part_of_speech_id).name + ':' +
            synset.definition + ':' +
            sequence.th_sort_type_direction.th_sort_type.label + ':' +
            sequence.th_sort_type_direction.th_sort_direction.label
          )
          entry_seq = ThEntrySequence.create(
            :th_entry_id => entry.th_entry_id,
            :th_sequence_id => sequence.th_sequence_id
          )
          thesortus_entry = ThThesortusEntry.create(
            :th_thesortus_id => MyThesortus.th_thesortus_id,
            :th_entry_id => entry.th_entry_id
          )
  end

 ## def createEntries(sequence_ids)
 ## end #createEntries

  def sequencePrimaries(synsets)
    #
    #A synset's "primaries" are those words/phrases in the set; i.e., its collection of synonyms
    #Those synsets (via parameterization)  whose synset_t2_map(s) indicates its primaries have
    #not yet been sequenced are done so here. 
    #
    progress=0
    synsets.each do |synset|
      unless (synsetmaps=SynsetT2Map.find_all_by_synset_id(synset.synsetid))==[]
        synsetmaps.each do |synmap|
######Console progress indicator##################              
          progress=progress+1
          if progress%9==0
            print '.'
            if progress%100==0
              print "+\n"
            end
          end
##################################################
          unless ((synmap.th_sequence_id==nil) || 
                  (synmap.primaries_sequenced) || 
                  (synmap.th_phrase_definition_id==nil))
            #Add this phrase/definition pair as a ThMember of sequence.
            th_member = ThMember.create(:th_sequence_id => synmap.th_sequence_id,
                                        :th_phrase_definition_id => synmap.th_phrase_definition_id,
                                        :ordinality => PRIMARY_ORD,
                                        :th_mod_info_id => MyDModInfo.id)
            #Set the flag to indicate that the primary word/phrase for this phrase/definition pair
            #has been added as member to the sequence.
            synmap.update_attribute(:primaries_sequenced, TRUE)
          end
        end
      end
    end
  end

  def sequenceSimilars(synsets)
    #
    #A synset's "similars" are those words/phrases found using WordNet::Synset#similar_words.
    #Those synsets (via parameterization)  whose synset_t2_map(s) indicates its similars have
    #not yet been sequenced are done so here. 
    #
    progress = 0
    i=0
    synsets.each do |synset|
      i=i+1
  ##    log.unknown i.to_s + " Similars OUTER LOOP for synset #: " + synset.synsetid.to_s
      #Confirm that this synset has been mapped. If not, there is no sequence to work with.
  ##  unless (synsetmaps=SynsetT2Map.find_all_by_synset_id(synset.synsetid))==nil
      unless (synsetmap=SynsetT2Map.find_by_synset_id(synset.synsetid))==nil

        #A synset with N words has N SynsetT2Map entries, one for each (word)X(definition) pair.
        #Each such pair shares the same sequence, so we only need to look at each synset once.
        
  ## synsetmaps.each do |synsetmap|
######Console progress indicator##################              
          progress=progress+1
          if progress%9==0
            print '.'
            if progress%100==0
              print "+\n"
            end
          end
##################################################
          #Confirm that this synset has been sequenced
          unless ((synsetmap.th_sequence_id==nil) || 
                  #   (!synsetmap.primaries_sequenced) || 
                  (synsetmap.th_phrase_definition_id==nil) ||
                  (synsetmap.similars_sequenced))
            puts "Looking at " + synset.to_s
            puts "*********"
            j=0
            synset.similar_words.each do |sset|
              puts "     +++++++"
              puts "     Similar:  "+sset.to_s
              j=j+1
   ##       ##    log.unknown "   " + i.to_s + " " + j.to_s + " Similars INNER LOOP for similar (word) synset #: " + sset.synsetid.to_s
              unless (simmap = SynsetT2Map.find_by_synset_id(sset.synsetid))==nil
                #Add this phrase/definition pair as a ThMember of sequence.
                th_member = ThMember.create(:th_sequence_id => simmap.th_sequence_id,
                                            :th_phrase_definition_id => synsetmap.th_phrase_definition_id,
                                            :ordinality => SIMILARS_ORD,
                                            :th_mod_info_id => MyDModInfo.id)
                log.unknown "       CREATED similar MEMBER " + th_member.th_sequence_id.to_s + " " + th_member.th_phrase_definition_id.to_s
                #Set the flag to indicate that the primary word/phrase for this phrase/definition pair
                #has been added as member to the sequence.
                synsetmap.update_attribute(:similars_sequenced, TRUE)
    ## end
            end
          end
        end
      end
    end
  end

  def sequenceAntonyms(synsets)
    #
    #A synset's "antonyms" are ...
    #
    log.unknown("Begin sequencing antonyms")
    progress = 0
    i=0
    synsets.each do |synset|
      i=i+1
      ##  log.unknown i.to_s + "Antonym OUTER LOOP for synset #: " + synset.synsetid.to_s
      #Confirm that this synset has been mapped. If not, there is no sequence to work with.
      ##  unless (synsetmaps=SynsetT2Map.find_all_by_synset_id(synset.synsetid))==nil
      unless (synsetmap=SynsetT2Map.find_by_synset_id(synset.synsetid))==nil
        puts "Looking at " + synset.to_s
        puts "*********"
        #A synset with N words has N SynsetT2Map entries, one for each (word)X(definition) pair.
        #Each such pair shares the same sequence, so we only need to look at each synset once.
        ###    synsetmaps.each do |synsetmap|
        ######Console progress indicator##################              
        progress=progress+1
        if progress%9==0
          print '.'
          if progress%100==0
            print "+\n"
          end
        end
        ##################################################
        #Confirm that this synset has been sequenced
        unless ((synsetmap.th_sequence_id==nil) || 
                #   (!synsetmap.primaries_sequenced) || 
                (synsetmap.th_phrase_definition_id==nil) ||
                (synsetmap.antonyms_sequenced))
          j=0

            Synset.findAntonyms(synset).each do |sset|
              puts "     +++++++"
              puts "     Antonym:  "+sset.to_s
              j=j+1
    ##          log.unknown "   " + i.to_s + " " + j.to_s + " INNER LOOP for antonym synset #: " +  sset.synsetid.to_s
              unless (simmap = SynsetT2Map.find_by_synset_id(sset.synsetid))==nil
                simmap 
                #Add this phrase/definition pair as a ThMember of sequence.
                th_member = ThMember.create(:th_sequence_id => simmap.th_sequence_id,
                                            :th_phrase_definition_id => synsetmap.th_phrase_definition_id,
                                            :ordinality => ANTONYMS_ORD,
                                            :th_mod_info_id => MyDModInfo.id)
                log.unknown "       CREATED MEMBER " + th_member.th_sequence_id.to_s + " " + th_member.th_phrase_definition_id.to_s
                #Set the flag to indicate that the primary word/phrase for this phrase/definition pair
                #has been added as member to the sequence.
                synsetmap.update_attribute(:antonyms_sequenced, TRUE)

            end
          end
        end
      end
    end
    log.unknown("End sequencing antonyms")
  end #sequenceAntonyms

end #class SeedHandler
