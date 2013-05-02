#  © Copyright 2013 Groove Unlimited, LLC - All Rights Reserved.
#  Unauthorized copying of this file via any medium is strictly prohibited. 
#  Content herein may be proprietary and/or confidential.

module Seedit 


  USER_Props = APP_CONFIG["user"] # Pre-configures user properties
  MyUser  = ThUser.find_or_create_by_th_userId(USER_Props["id"])
  # Note: Before save, MyUser's other attributes are initialized in the ThUser model
  EDIT_Props = APP_CONFIG["editor"] # Pre-configures user properties
  MyEditAction  = ThEditorAction.find_or_create_by_name_and_description(EDIT_Props["action"]["default_name"],EDIT_Props["action"]["default_description"])
  # Note: Before save, MyEditAction's other attributes (if any) could be initialized in the ThEditorAction model
  OTK_Props = APP_CONFIG["ontoltoolkit"] # Pre-configured ontology tool kit properties
  MyToolKit  = OntolToolKit.find_or_create_by_name_and_version(OTK_Props["name"], OTK_Props["version"])
  # Note: Before save, MyToolKit's other attributes are initialized in OntolToolKit model
  MyToolKit.update_attribute(:otk_type,OntolToolKitType.find_or_create_by_name_and_category(OTK_Props["type"]["name"],OTK_Props["type"]["category"]).id)

  ONTOL_Props = OTK_Props["ontology"] # Pre-configured ontology 
  #TODO This is incomplete
  MyOntol  = Ontology.find_or_create_by_name_and_version(ONTOL_Props["name"], ONTOL_Props["version"])
  # Note: Before save, MyOntol's other attributes are initialized in model
  #    MyOntol.update_attribute(:ontology_type, OntologyType.find_or_create_by_name_and_category(ONTOL_Props["type"]["name"], ONTOL_Props["type"]["category"]).id)
  MyOntol.update_attribute(:ontology_type, OntologyType.find_or_create_by_name_and_category(ONTOL_Props["type"]["name"], ONTOL_Props["type"]["category"]))
  MyOntol.update_attribute(:description,ONTOL_Props["description"])

  ALG_Props = APP_CONFIG["algorithm"]       # Pre-configured algorithm properties
  Me =ThAlgorithm.find_or_create_by_name(ALG_Props["name"])
  ##  # Note: Before save, Me's other attributes are initialized in model
  ##
  ##  Me.myToolKit = MyToolKit
  MyToolKit.update_attribute(:ontologyId, MyOntol.id)
  ##  Me.update_attribute(:ontolToolKitId, MyToolKit.id)
  ##
  Lexs = MyOntol.classname.constantize.new
  MyToolKit.ontology = Lexs


  SRC_TYPE_Props = {'name' => MyOntol.name + MyOntol.version, 'description' => MyOntol.description}
  Src_type = ThSourceType.find_or_create_by_name(SRC_TYPE_Props['name'])
  Src_type.update_attribute(:description,  SRC_TYPE_Props['description'])


  SRC_Props = {'th_source_type_id' => Src_type.id.to_s, 'th_user_id' => MyUser.id.to_s, 'th_algorithm_id'=> Me.id.to_s} 

  class Seeder
    def initialize #automatically invoked when a Seeder is created with Seeder.new
      puts "b"
      @myUserId = MyUser.th_userId
      @lexs = Lexs
      #The following is inconsistent with how lexs is generated.
      @words = WordNet::Word 
      @editAction = MyEditAction.th_editor_action_id
      @srcProps = SRC_Props
    end #initialize


    def clear(tablenames) #Utility development function to clear data from tables
      #TODO: Move to a utils class
      tablenames.each {|tname| Object.const_get(tname).delete_all}
    end

    def harvestWordsIntoPhrases
      #Get words and related info from WordNet and put them into the T2 database.
      @words.limit(10).each do |word| #TODO: Remove limit for production
        lemma = word.lemma
        unless ThPhrase.find_by_lemma(lemma) 
          extRefId = word.wordid
          thisPhrase=ThPhrase.new(:lemma=>lemma,:th_editor_action_id=>@editAction)
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
      @words.limit(10).each do |word| #TODO: Remove limit for production
        #find this word in the th_phrase table. If it's not there, we'll skip to the next word
        lemma = word.lemma
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
                if thisSynsetsSrc=ThSource.create(@srcProps.merge("external_ref_id"=>extRefId))
                  puts "saved the def source"                        
   HERE--->     ################  thisSynsetsDef.update_attribute(:th_source_id => thisSynsetsSrc.id)
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

    def sowPhrasesFromLex
      unless self.lexs==nil  #unless 1
        #TODO: The following statement is reinstated for production run
        #lexsize=WordNet::Word.count
        lexsize = 5 
        lexsize.times do |i|
          idx = i+1
          word = lexs[idx]   # word is an alias for lexs[idx]
          phrase_src= ThSource.new(@srcProps)
          # TODO: A new phrase is added if it's lemma is unique.  Modify to allow the same lemma from multiple sources.  
          unless ThPhrase.find_by_lemma(word.lemma)  # unless 2
            # Create a new phrase object for word. It will be added to the _phrase table once a sourceID is obtained.
            th_ph=ThPhrase.new(:lemma=>word.lemma,:th_editor_action_id=>@editAction)
            phrase_src.external_ref_id = word.wordid
            if phrase_src.save
              puts "saved phrase source with id "+ phrase_src.id.to_s
              th_ph.th_source_id = phrase_src.id
            else puts phrase_src.errors.messages["source save error"]
            end
            if th_ph.save
              puts "saved "+ th_ph.lemma
            else puts th_ph.errors.messages[:lemma]
            end
            #get phrase senses from their synsets
            synsets=lexs.lookup_synsets(th_ph.lemma)
            puts "lex lookup"
            unless synsets==nil
              synsets.each do |synset|
                unless synset==nil
                  #This source is for this sense of the phrase
                  synset_src  = ThSource.new(SRC_Props)
                  synset_src.external_ref_id = synset.synsetid
                  #Now to the definition for this sense of the phrase
                  th_def = ThDefinition.new(:definition=> synset.definition,:th_source_id => synset_src.id,:th_editor_action_id=>@editAction)
                  puts "not nil"
                  if synset_src.save
                    th_def.th_source_id= synset_src.id
                  else puts synset_src.errors.messages["source save error"]
                  end
                  if th_def.save  #Save the phrase definition for this sense
                    puts "saved " + th_def.definition

                    # create and save the th_phrase_definition
                    th_phr_definition = ThPhraseDefinition.new(:th_phrase_id=>th_ph.id, :th_definition_id=>th_def.id,:th_source_id=>synset_src.id, :th_editor_action_id=>@editAction)
                    if th_phr_definition.save
                      puts "save the phrase defintion object"
                      # Create the records for and save the phrase sense's metadata
                      synset.to_hash.each do  |key,value|
                        #TODO: The definition is included in this hash.  Should we include it in the metadata table?
                        #For now is excluded.
                        if !(key.to_s.eql? "definition")
                          puts "this key is :" + key.to_s + ":"
                          meta_d = ThMetadatum.new(:key => key,:value => value.to_s, :th_phrase_definition_id=> th_phr_definition.id)
                          meta_d.save 
                          puts "meta_d saved"
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
          th_phr = lexs[idx+1]
          puts th_phr.lemma
          puts idx 
        end #lexsize.times do
      end #unless 1

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
      self.lexs.count
    end #sizeOfLexicon
  end #class Seeder
end #module 
