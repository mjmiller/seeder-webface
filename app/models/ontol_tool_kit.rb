#  © Copyright 2013 Groove Unlimited, LLC - All Rights Reserved.
#  Unauthorized copying of this file via any medium is strictly prohibited. 
#  Content herein may be proprietary and/or confidential.

class OntolToolKit < ActiveRecord::Base
  validates :name, :uniqueness => {:scope => :version}
  attr_accessible :description, :name, :ontologyId, :otk_type, :version
  attr_accessor :ontology

  before_save :init_attributes

=begin rdoc
  TODO: migration needed for a new otk_types table with columns   ID, NAME, DESCR. 
  FIXME: Once OTK_Types tables is created modify config.yml and init_attributes accordingly
=end
  def init_attributes 
     #TODO: Make init_attributes DRY
     self.attributes.keys.each do |key|
      if APP_CONFIG["ontoltoolkit"].key?(key)
         self[key.to_sym] = APP_CONFIG["ontoltoolkit"][key]
      end
   end
 end
   


   def phraser
      # phraser havests ontologies for ThPhrases, ThPhraseSenses, ThMetadatum, and ThSources.
      # The ontology from which these are harvested is called lex (short for lexicon).

      # When lex is a WordNet::Lexicon, we harvest it's WordNet::Word(s). These are
      # systematically transformed into ThPhrase(s). Part of the transformation process
      # records data about the word's source in a unique ThSource record, retrievable with
      # the the appropriate ThPhrase's ID.
      
      # ThPhraseSenses are derived from a word's WordNet::Sense(s). Each sense produces one
      # ThPhraseSense. As with words, sense data is preserved in a unique ThSource, retrievable
      # using the appropriate ThPhraseSense's ID.
      
      # TODO: Complete the above description with a brief discussion of ThMetadatum.

      lex = self.ontology # lex is the lexicon from which new T2::ThPhrase(s) are harvested
                          # When lex is a WordNet::Lexicon, we harvest WordNet::Word(s) from lex
                          # In what follows, "word(s)" refers to the WordNet object(s)
      unless lex==nil
      # TODO:  automate lex.getSize
     #  sz = 147306  # the number of words in WordNet::Lexicon defaultDB
     #  sz = 30
        sz = 3
      #  sz = 1
       sz.times do |i|
       # Display progress
       if (i%350 == 0 )
        print "."
       end
       idx = i+1
      # TODO: Remove random num generator when not needed
        # idx = Random.rand(105000) #for testing
         # This source is for the phrase
         # phrase_src = ThSource.new :thSourceTypeId => MyOntol.name, :thUserId => Me.id.to_s
         phrase_src  = ThSource.new(SRC_Props)

         word = lex[idx]   # word is an alias for lex[idx]
       # Display progress
       if (i%3500 == 0 )
        print  word.lemma
       end
         phrase_src.extRefId = lex[idx].wordid
         # TODO: A new phrase is added if it's lemma is unique.  Modify to allow the same lemma from multiple sources.  
         unless ThPhrase.find_by_lemma(word.lemma) 
            # Create a new phrase object for WORD. It will be added to the _phrase table once a sourceID is obtained.
            ph=ThPhrase.new(:lemma=>word.lemma)
            if phrase_src.save
               puts "saved phrase source with id "+ phrase_src.id.to_s
               ph.thSourceId = phrase_src.id
            else puts phrase_src.errors.messages["source save error"]
            end
            if ph.save
               puts "saved "+ ph.lemma
            else puts ph.errors.messages[:lemma]
            end
            #get phrase senses from their synsets
            synsets=lex.lookup_synsets(ph.lemma)
            unless synsets==nil
               synsets.each do |synset|
                  unless synset==nil
                    #This source is for this sense of the phrase
                    synset_src  = ThSource.new(SRC_Props)
                    synset_src.extRefId = synset.synsetid
                    phr_sense = ThPhraseSense.new(:description => synset.definition,:thPhraseId => ph.id)
                    if synset_src.save
                       puts "saved phrasesense source with id "+ synset_src.id.to_s
                       phr_sense.thSourceId = synset_src.id
                    else puts synset_src.errors.messages["source save error"]
                    end
                     if phr_sense.save
                        puts "saved " + phr_sense.description
                        # Create the records for and save the phrase sense's metadata
                        synset.to_hash.each do  |key,value|
                            meta_d = ThMetadatum.new(:key => key,:value => value, :thPhraseSenseId => phr_sense.id)
                            meta_d.save 
                         end
                     end

                    # #These are the lemmas (base forms) of the words included in syn
                    # synset.words.map(&:lemma).each do |membr|
                    #    #TODO: Replace ThEntry with ThMember, as it should be, and change attributes accordingly. This is for demo (viewing) purposes only
                    #    memburr=ThEntry.new(:title =>"FOR: "+ ph.lemma, :description => "I FOUND THE SYN: "+ membr)
                    #    if memburr.save
                    #       puts "saved the member "+ membr
                    #    end
                    # end

                  end
               end
            end
         end
       end
     end
   end #phraser
   
#   def synser
#      # TODO: Rewrite this copy of phraser into a new synser.
#      # synser harvests ontologies for ThPhrases, ThPhraseSenses, ThMetadatum, and ThSources.
#      # The ontology from which these are harvested is called lex (short for lexicon).
#
#      # When lex is a WordNet::Lexicon, we harvest it's WordNet::Word(s). These are
#      # systematically transformed into ThPhrase(s). Part of the transformation process
#      # records data about the word's source in a unique ThSource record, retrievable with
#      # the the appropriate ThPhrase's ID.
#      
#      # ThPhraseSenses are derived from a word's WordNet::Sense(s). Each sense produces one
#      # ThPhraseSense. As with words, sense data is preserved in a unique ThSource, retrievable
#      # using the appropriate ThPhraseSense's ID.
#      
#      # TODO: Complete the above description with a brief discussion of ThMetadatum.
#
#      lex = self.ontology # lex is the lexicon from which new T2::ThPhrase(s) are harvested
#                          # When lex is a WordNet::Lexicon, we harvest WordNet::Word(s) from lex
#                          # In what follows, "word(s)" refers to the WordNet object(s)
#      unless lex==nil
#      # TODO: Remove random num generator when not needed
#       2.times do |i|
#       # idx = Random.rand(105000)
#        idx = lex[i]
#         # This source is for the phrase
#
#         word = lex[idx]   # word is a convenient alias for lex[idx]
#            #get phrase senses from their synsets
#         synsets=lex.lookup_synsets(word.lemma)
#         unless synsets==nil
#            synsets.each do |synset|
#                unless synset==nil
#                    #This source is for this sense of the phrase
#                    synset_src  = ThSource.new(SRC_Props)
#                    synset_src.extRefId = synset.synsetid
#                    phr_sense = ThPhraseSense.new(:description => synset.definition,:thPhraseId => ph.id)
#                    if synset_src.save
#                       puts "saved phrasesense source with id "+ synset_src.id.to_s
#                       phr_sense.thSourceId = synset_src.id
#                    else puts synset_src.errors.messages["source save error"]
#                    end
#                     if phr_sense.save
#                        puts "saved " + phr_sense.description
#                        # Create the records for and save the phrase sense's metadata
#                        synset.to_hash.each do  |key,value|
#                            meta_d = ThMetadatum.new(:key => key,:value => value, :thPhraseSenseId => phr_sense.id)
#                            meta_d.save 
#                         end
#                     end
#
#                    # #These are the lemmas (base forms) of the words included in syn
#                    # synset.words.map(&:lemma).each do |membr|
#                    #    #TODO: Replace ThEntry with ThMember, as it should be, and change attributes accordingly. This is for demo (viewing) purposes only
#                    #    memburr=ThEntry.new(:title =>"FOR: "+ ph.lemma, :description => "I FOUND THE SYN: "+ membr)
#                    #    if memburr.save
#                    #       puts "saved the member "+ membr
#                    #    end
#                    # end
#
#                  end
#               end
#            end
#         end
#       end
#     end
#   end #synser
   
end
