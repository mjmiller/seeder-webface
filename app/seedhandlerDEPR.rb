require_relative 't2seeder'
require_relative 'utils/wnt2dictionary'

  class SeedHandler
    def initialize #automatically invoked when a SeedHandler is created with SeedHandler.new
      @myUserId = MyUser.th_userId
      @lexs = Lexs
      #The following is inconsistent with how lexs is generated.
      @words = WordNet::Word 
      @editAction = MyEditAction.th_editor_action_id
      @srcProps = SRC_Props

    end #initialize


    def self.clear(tablenames) #Utility development function to clear data from tables
      #TODO: Move to a utils class
      tablenames.each {|tname| Object.const_get(tname).delete_all}
    end

    def self.seedBySynset(synsets)
      ordinalityofprimarysset = 1
      ordinalityofsimilars = 2
      i=1
      synsets.each do |synset|
        i+=1
        puts i
      #Create a ThSeqeunce entry for this synset and its relatives.
      sequence = ThSequence.create(:th_sort_type_direction_id => MyDSortTypeDirection.id,
                                 :th_mod_info_id => MyDModInfo.id,
                                 :th_part_of_speech_id => ThPartOfSpeech.find_by_name(Wnt2dictionary.translate_into_t2(synset.pos)).id)
        #Process this synset into a collection of T2 phrases, definitions, and a sequence.
        self.synset2T2components(synset, ordinalityofprimarysset, sequence)
        #Now collect 'similar_words' to this synset, and process them as above.
        #Note: Despite it's name, 'similar_words' returns a synset.
        #Also note: We don't recurse. Rather, we go one level deep to keep similarity strong.
       sql="SELECT `synsetid` FROM `synsets` WHERE (`synsetid` IN (SELECT `synset2id` FROM `lexlinks` WHERE ((`lexlinks`.`synset1id` ="+synset.synsetid.to_s+") AND (`linkid` = "+WordNet::Synset.linktypes[:antonym][:id].to_s+"))))"
       res =  WNConn.query(sql)
       res.each do |row|
         puts synset
         puts WordNet::Synset[row]
         puts '********'
       end
        synset.similar_words.each do |sim|
        #  puts sim
          self.synset2T2components(sim, ordinalityofsimilars, sequence)
        end

        #puts 'SIMILARS ^'
        #puts synset.also_see
        #puts 'ALSO SEES ^'
        #puts synset.senses
        #puts 'SENSES ^'
      end
    end

    def self.synset2T2components(synset, ordinality=MyDOrdinality, sequence)
      synsettype = ObjType.find_by_name(:synset).id
      processingstatus = ProcessStatus.find_by_name(:found).id

      #Make sure this synset only appears in the obj_process_status table once
      unless ObjProcessStatus.find_by_source_id_and_obj_type_id(synset.synsetid,  synsettype) 
        #add this synset to the set of those found thus far
      this_objs_status =  ObjProcessStatus.create(:obj_type_id => synsettype, :source_id => synset.synsetid, :process_status_id => processingstatus)
      end
      # Each word in synset is a WordNet synonym to the others. 
      # Add it as a member of the newly created sequence, each with equal ordinality.
      synset.words.each do |word|
        # First find the word in T2's database, or create a new entry if it isn't in there.
        th_phrase = ThPhrase.find_or_create_by_lemma(word.lemma)
        # A ThPhraseDefinition id is needed so create one.  Note that even if
        # this word had been in T2's database associated with other ThPhraseDefinitions,
        # a new ThPhraseDefinition is required for this definition.
        # Create a ThDefinition entry
        th_def = ThDefinition.create(:definition => synset.definition, 
                                   :th_part_of_speech_id => sequence.th_part_of_speech_id,
                                   :th_mod_info_id => MyDModInfo.id)
        th_phrase_def = ThPhraseDefinition.create(:th_phrase_id => th_phrase.id,
                                                  :th_definition_id => th_def.id,
                                                  :th_mod_info_id => MyDModInfo.id)
        #Add this word/phrase as a ThMember of sequence.
        th_member = ThMember.create(:th_sequence_id => sequence.id,
                                    :th_phrase_definition_id => th_phrase_def.id,
                                    :ordinality => ordinality,
                                    :th_mod_info_id => MyDModInfo.id)

        this_objs_status.update_attribute(:process_status_id,  ProcessStatus.find_by_name(:processed).id)
      end
    end

    def self.sequence2DfltEntry(sequence)
      #Gloss: Naive construction of a ThEntry from a ThSequence
      #Params: sequence::ThSequence
      unless ThEntry.find_by_th_sequence_default_id(sequence.th_sequence_id)
      entry = ThEntry.create(
        :th_sequence_default_id => sequence.id, 
        :th_mod_info_id => MyDModInfo.id,
        :title => 'Seeded sequence for words related to: ' +
            sequence.th_members.first.th_phrase_definition.th_phrase.lemma,
        :description => ThPartOfSpeech.find_by_th_part_of_speech_id(sequence.th_part_of_speech_id).name + ':' + 
            sequence.th_members.first.th_phrase_definition.th_phrase.lemma + ':' + 
            sequence.th_members.first.th_phrase_definition.th_definition.definition + ':' +
            sequence.th_sort_type_direction.th_sort_type.label + ':' +
            sequence.th_sort_type_direction.th_sort_direction.label
      )
      end
    end #sequence2DfltEntry



def harvestWordsIntoPhrases
  #Get words and related info from WordNet and put them into the T2 database.
  @words.limit(10).each do |word| #TODO: Remove limit for production
    lemma = word.lemma
    unless ThPhrase.find_by_lemma(lemma) 
      extRefId = word.wordid
      thisPhrase=ThPhrase.create(:lemma=>lemma,:th_editor_action_id=>@editAction)
      if thisPhrase.save
        puts "saved the phrase " + thisPhrase.lemma
        if thisPhrasesSrc=ThSource.create(@srcProps.merge("external_ref_id"=>extRefId))
          puts "saved the phrase source"                        
          thisPhrase.update_attribute(:th_source_id, thisPhrasesSrc.id)
        end
      end
    end #unless ThPhrase.find_by_lemma
  end
end

    def harvestSynsetsIntoPhraseDefs
            puts "anew"
      @words.limit(10).each do |word| #TODO: Remove limit for production
        #find this word in the th_phrase table. If it's not there, we'll skip to the next word
        lemma = word.lemma
            puts "new"
        if thPhrase = ThPhrase.find_by_lemma(lemma)

          #get synsets for this word
          thisWordsSynsets=@lexs.lookup_synsets(lemma)
          unless thisWordsSynsets==nil
            thisWordsSynsets.each do |synset|
              definition = synset.definition
              # Is this definition already in ThDefinitions?
              if !(ThDefinition.find_by_definition(definition))
                thisSynsetsDef = ThDefinition.create(:definition => definition, :th_editor_action_id => @editAction)
                #This source is for this sense of the phrase
                #Get and record its external id
                extRefId = synset.synsetid
                if thisSynsetsSrc=ThSourceAction.create(@srcProps.merge("external_ref_id"=>extRefId))
                  puts "saved the def source"                        
   #HERE--->     ################  thisSynsetsDef.update_attribute(:th_source_id => thisSynsetsSrc.id)
            puts "debug 1"
                end
              else #(ThDefinition.find_by_definition(definition)) is true
                puts "Oops, this definition is already in the table.  WHAT NOW?"
              end
               # The def is now guaranteed to be in ThDefinitions. We need its id for ThPhraseDefinition. 
            puts "debug 2"
                thisDefId = ThDefinition.find_by_definition(definition)
            puts "debug 3"
                if ThPhraseDefinition.create(:th_definition_id => thisDefId, :th_editor_id => @editAction, :th_phrase_id => thPhrase.id)
                  puts "new ThPhraseDefinition created"
                  #TODO: Is this where th_metadata table entry gets created/set?
                end 
            end
          end
        end
      end
    end

    def sowPhrasesFromLex (wordsource = @lexs, lexsize = 10)
      unless @lexs==nil  #unless 1
        #TODO: The thPhrDefArray is to operate as a return value. More should be added to it, but for now we leave it as is.
         thPhrDefArray = []
        #
        #TODO: The following statement is reinstated for production run
        #lexsize=WordNet::Word.count
        lexsize.times do |i|
          
          
          #idx = i+1
          idx = i

         # word = @lexs[idx]   # word is an alias for lexs[idx]
         word = wordsource[idx]   # word is an alias for lexs[idx]

          phrase_src= ThSource.new(@srcProps)

          #A th_mod_info entry is made for each modification made to T2 content.  Prepare the ThModInfo object.
          phrase_mod_info = ThModInfo.new(:th_editor_action_id => MyEditAction.id)

          # TODO: A new phrase is added if it's lemma is unique.  Modify to allow the same lemma from multiple sources.  
          unless ThPhrase.find_by_lemma(word.lemma)  # unless 2
            # Create a new phrase object for word. It will be added to the _phrase table once a sourceID is obtained.
            th_ph=ThPhrase.new(:lemma=>word.lemma)
            phrase_src.external_ref_id = word.wordid
            if phrase_src.save
              puts "saved phrase source with id "+ phrase_src.id.to_s
              phrase_mod_info.th_source_id = phrase_src.id
            else puts phrase_src.errors.messages["source save error"]
            end

            if phrase_mod_info.save
              puts "saved the mod info for phrase "+th_ph.lemma+"'s entry"
            #  th_ph.th_mod_info_id = phrase_mod_info.id
            else puts phrase_src.errors.messages["mod info save error"]
            end
              if th_ph.save
                puts "saved "+ th_ph.lemma
              else puts th_ph.errors.messages[:lemma]
              end
              #get phrase senses from their synsets
              synsets=@lexs.lookup_synsets(th_ph.lemma)
              puts "lex lookup"
              unless synsets==nil
                synsets.each do |synset|
                  unless synset==nil
                    #This source is for this sense of the phrase
                    synset_src  = ThSource.new(SRC_Props)
                    synset_src.external_ref_id = synset.synsetid
                    #Prep th_mod_info entry
                    synset_mod_info = ThModInfo.new(:th_editor_action_id => MyEditAction.id)
                    #Now to the definition for this sense of the phrase
                    th_def = ThDefinition.new(:definition=> synset.definition)
                    puts "not nil"
                    if synset_src.save
                      synset_mod_info.th_source_id= synset_src.id
                      if synset_mod_info.save
                        th_def.th_mod_info_id=synset_mod_info.id

                      else puts synset_src.errors.messages["synset mod info save error"]
                      end
                    else puts synset_src.errors.messages["synset source save error"]
                    end
                    if th_def.save  #Save the phrase definition for this sense
                      puts "saved " + th_def.definition

                      # create and save the th_phrase_definition
                      th_phr_definition = ThPhraseDefinition.new(:th_phrase_id=>th_ph.id, :th_definition_id=>th_def.id,:th_mod_info_id=>synset_mod_info.id)
                      if th_phr_definition.save
                        thPhrDefArray.push(th_phr_definition.id)
                        puts "save the phrase defintion object"
                        # Create the records for and save the phrase sense's metadata
                        puts synset
                        synset.to_hash.each do  |key,value|
                          #The definition is included in this hash. It has already been entered as a ThDefinition. It is excluded from entry in the metadata tables.
                          if !(key.to_s == "definition")
                            if (key.to_s == "pos")
                              case value.to_s 
                              when "n"
                                pos = "noun"
                              when "v"
                                pos = "verb"
                              when "a"
                                pos = "adjective"
                              when "r"
                                pos = "adverb"
                              when "s"
                                pos = "adjective satellite"
                              else
                                puts "I don't know that part of speech" + value.to_s
                              end
                            puts "did i get here?"
                            puts pos
                              th_def.update_attribute(:th_part_of_speech_id, ThPartOfSpeech.find_by_name(Wnt2dictionary.translate_into_t2(pos)).id)
                            puts "part of speech attribute updated"
                            else
                            puts "create a ThModInfo object"
                            key_mod_info = ThModInfo.create(:th_source_id => synset_src.id, :th_editor_action_id => MyEditAction.id)
                            puts "ThModInfo created"
                            meta_data_key = ThMetadataKey.new(:key => key,:description => "some description",:th_mod_info_id => key_mod_info.id, :th_data_type_id => MyDDataType.id)
                            # :value => value.to_s, :th_phrase_definition_id=> th_phr_definition.id)
                            meta_data_key.save 
                            puts "meta data key saved"
                            meta_data= ThMetadatum.create(:th_phrase_definition_id => th_phr_definition.id, :th_metadata_key_id => meta_data_key.id, :value => value )
                            end
                          end 
                        end
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

          end #unless 2

          #th_phr = @lexs[idx+1]
       ##    th_phr = wordsource[idx+1]
       ##   puts th_phr.lemma
       ##  puts idx 
        end #lexsize.times do
      end #unless 1
thPhrDefArray 
    end #sowPhrases

    # def initialize(args = nil)
    #   args = args ? DEFAULTS.merge(args) : DEFAULTS
    # 
    #   ATTRIBUTES.each do |attr|
    #     if (args.key?(attr))
    #       instance_variable_set("@#{attr}", args[attr])
    #     end
    #   end
    # end
    # 
    # def inspect
    #   ATTRIBUTES.inject({ }) do |h, attr|
    #     h[attr] = instance_variable_get("@#{attr}")
    #     h
    #   end
    # end
    # 
    # def a #get phrases from the source's lexicon into phrases table
    #    src = Source.new

    #create an unpredictable string to use as a label
    #    src.label=Integer(Time.now.nsec).to_s 

    #   src.lexicon = Lexs
    #   if src.label
    #     unless src.save #if this source is *not* saved...
    #       puts "unable to save this source...returning"
    #       return
    #     end
    #   end
    #   puts src.label
    #   puts src
    #   src.phraseEms
    # end #a
    # 
    def sizeOfLexicon()  #get the size of Seeder's lexicons
      # lexicon = self.lexs
      # $stdout.sync = true # See http://stackoverflow.com/questions/5080644/how-can-i-use-puts-to-the-console-without-a-line-break-in-ruby-on-rails
      # i = 0
      # puts "This will take a moment. Hang on."
      # until lexicon[i+1] == nil
      #   i+=1
      #   if (i%1350 == 0 )
      #     print "."
      #     sleep(0.001)
      #   end
      # end
      # #    puts "\n"+ Integer(i).to_s+"   "+lexicon[i].lemma #This is the last lexicon element
      # puts "\n"
      # i
      @lexs.count
    end #sizeOfLexicon
  end #class Seeder
