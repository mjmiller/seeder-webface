#  © Copyright 2013 Groove Unlimited, LLC - All Rights Reserved.
#  Unauthorized copying of this file via any medium is strictly prohibited. 
#  Content herein may be proprietary and/or confidential.

module Tryitout


  # This is the entry point for the command line initialization of T2Seeder.
  # This module uses the APP_CONFIG hash to initialize several global constants.
  # APP_CONFIG is kj
   
   USER_Props =APP_CONFIG["user"]            # Pre-configures user properties
  MyUser  = ThUser.find_or_create_by_username(USER_Props["username"])
  # Note: Before save, MyUser's other attributes are initialized in model

   OTK_Props = APP_CONFIG["ontoltoolkit"]    # Pre-configured ontology tool kit properties
  MyToolKit  = OntolToolKit.find_or_create_by_name_and_version(OTK_Props["name"], OTK_Props["version"])
  # Note: Before save, MyToolKit's other attributes are initialized in model
  MyToolKit.update_attribute(:otk_type,OntolToolKitType.find_or_create_by_name_and_category(OTK_Props["type"]["name"],OTK_Props["type"]["category"]).id)

   ONTOL_Props = OTK_Props["ontology"]    # Pre-configured ontology 
  MyOntol  = Ontology.find_or_create_by_name_and_version(ONTOL_Props["name"], ONTOL_Props["version"])
  # Note: Before save, MyOntol's other attributes are initialized in model
  MyOntol.update_attribute(:o_type, OntologyType.find_or_create_by_name_and_category(ONTOL_Props["type"]["name"], ONTOL_Props["type"]["category"]).id)
   
 
   ALG_Props = APP_CONFIG["algorithm"]       # Pre-configured algorithm properties
  Me =T2Seeder.find_or_create_by_name_and_version(ALG_Props["name"], ALG_Props["version"])
  # Note: Before save, Me's other attributes are initialized in model

  Me.myToolKit = MyToolKit
  Me.myToolKit.update_attribute(:ontologyId, MyOntol.id)
  Me.update_attribute(:ontolToolKitId, MyToolKit.id)

  Lexs = MyOntol.classname.constantize.new
  MyToolKit.ontology = Lexs
  

  SRC_TYPE_Props = {'name' => MyOntol.name + MyOntol.version, 'description' => MyOntol.description}
  Src_type = ThSourceType.find_or_create_by_name(SRC_TYPE_Props['name'])
  Src_type.update_attribute(:description,  SRC_TYPE_Props['description'])


  SRC_Props = {'thSourceTypeId' => Src_type.id.to_s, 'thUserId' => Me.id.to_s} 
     



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
  # def b  #get the size of Lexs
  #   $stdout.sync = true # See http://stackoverflow.com/questions/5080644/how-can-i-use-puts-to-the-console-without-a-line-break-in-ruby-on-rails
  #   i = 0
  #   until Lexs[i+1] == nil
  #     i+=1
  #     if (i%350 == 0 )
  #       print "."
  #       sleep(0.001)
  #     end
  #   end
  #   puts "\n"+ Integer(i).to_s+"   "+Lexs[i].lemma
  # end #b
  # 
  # def c
  #   puts "in c"
  #   puts "and out"
  # end
end
