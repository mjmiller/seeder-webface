#  © Copyright 2013 Groove Unlimited, LLC - All Rights Reserved.
#  Unauthorized copying of this file via any medium is strictly prohibited. 
#  Content herein may be proprietary and/or confidential.

require 'wordnet' unless defined?( WordNet )
require 'linguistics' unless defined? (Linguistics)
require 'mysql' unless defined? (Mysql)

module Developer 

  Linguistics.use(:en)
  USER_Props = APP_CONFIG["user"] # Pre-configures user properties
  MyUser  = ThUser.find_or_create_by_th_userId(USER_Props["id"])
  # Note: Before save, MyUser's other attributes are initialized in the ThUser model
  THESORTUS_Props = APP_CONFIG["thesortus"]
  MyThesortus = ThThesortu.joins{th_domain}.where{th_domain.name.eq THESORTUS_Props["domain"]}.first
  EDIT_Props = APP_CONFIG["editor"] # Pre-configures user properties
  MyEditAction  = ThEditorAction.find_or_create_by_name_and_description(EDIT_Props["action"]["new"]["name"],EDIT_Props["action"]["new"]["description"])
  MyDelEditAction  = ThEditorAction.find_or_create_by_name_and_description(EDIT_Props["action"]["delete"]["name"],EDIT_Props["action"]["delete"]["description"])
  MyModEditAction  = ThEditorAction.find_or_create_by_name_and_description(EDIT_Props["action"]["modify"]["name"],EDIT_Props["action"]["modify"]["description"])
  # Note: Before save, My<...>EditAction's other attributes (if any) could be initialized in the ThEditorAction model
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
  if !(Me = ThAlgorithm.find_by_name(ALG_Props["name"]))
    Me =ThAlgorithm.create(ALG_Props)
  end

  ##  # Note: Before save, Me's other attributes are initialized in model
  ##
  ##  Me.myToolKit = MyToolKit
  MyToolKit.update_attribute(:ontologyId, MyOntol.id)
  ##  Me.update_attribute(:ontolToolKitId, MyToolKit.id)
  ##



  WNConn = Mysql.new 'localhost', 'root', '', 'wordnet30'

  #To use WordNet::DefaultDB toggle commenting on the following 2 lines
  #Lexs = MyOntol.classname.constantize.new
  Lexs = WordNet::Lexicon.new(adapter:'mysql', database:'wordnet30',host:'localhost',user:'root' )
  MyToolKit.ontology = Lexs


  SRC_TYPE_Props = {'name' => MyOntol.name + MyOntol.version, 'description' => MyOntol.description}
  if !(Src_type = ThSourceType.find_by_name(SRC_TYPE_Props['name']))
    Src_type = ThSourceType.create(SRC_TYPE_Props)
  end
  SRC_Props = {'th_source_type_id' => Src_type.id.to_s, 'th_user_id' => MyUser.id.to_s, 'th_algorithm_id'=> Me.id.to_s} 

  #Create of find default table entries
  DFLT_Props = APP_CONFIG["defaults"] 
  #TODO: Change these from globals.  Put into a single class

  #TODO: Uncomment when ThDataType is implemented  \/ \/\/\/\/\/\/
  MyDDataType = ThDataType.find_or_initialize_by_name(DFLT_Props["data_type"]["name"])
  !MyDDataType.description ?  MyDDataType.update_attribute(:description, DFLT_Props["data_type"]["description"]) : nil   #update (and save) if no description exists yet. BTW, if   description is a DB required field, it's non-existence implies this is a newly formed object which should be saved and is by update_attribute.

  MyDSourceType = ThSourceType.find_or_initialize_by_name(DFLT_Props["source_type"]["name"])
  !MyDSourceType.description ?  MyDSourceType.update_attribute(:description, DFLT_Props["source_type"]["description"]) : nil   #update (and save) if no description exists yet. BTW, if   description is a DB required field, it's non-existence implies this is a newly formed object which should be saved and is by update_attribute.

  MyDSource = ThSource.find_or_initialize_by_th_source_type_id(MyDSourceType.id)
  !MyDSource.external_ref_id ?  MyDSource.update_attributes(:external_ref_id => DFLT_Props["external_ref_id"],  :th_user_id => MyUser.id, :th_source_type_id => MyDSourceType.id, :th_algorithm_id => Me.id ) : nil   #update (and save) if no external_ref_id exists yet. BTW, if  external_ref_id is a DB required field, it's non-existence implies this is a newly formed object which should be saved and is by update_attribute.

  MyDEditorAction = ThEditorAction.find_or_initialize_by_name(DFLT_Props["editor_action"]["name"])

  !MyDEditorAction.description ?  MyDEditorAction.update_attribute(:description, DFLT_Props["editor_action"]["description"]) : nil   #update (and save) if no description exists yet. BTW, if   description is a DB required field, it's non-existence implies this is a newly formed object which should be saved and is by update_attribute.

  MyDModInfo = ThModInfo.find_or_initialize_by_th_source_id(MyDSource.id)
  !MyDModInfo.th_editor_action_id ? MyDModInfo.update_attribute(:th_editor_action_id, MyDEditorAction.id) : nil #update (and save) if no th_editor_action_id exists yet. BTW, if   th_editor_action_id is a DB required field, it's non-existence implies this is a newly formed object which should be saved and is by update_attribute.

  MyDPartOfSpeech = ThPartOfSpeech.find_or_initialize_by_name(DFLT_Props["pos"]["name"])
  !MyDPartOfSpeech.abbr ? MyDPartOfSpeech.update_attribute(:abbr, DFLT_Props["pos"]["abbr"]) : nil #update (and save) if no abbr exists yet. BTW, if abbr is a DB required field, it's non-existence implies this is a newly formed object which should be saved and is by update_attribute.

  MyDPhrase = ThPhrase.find_or_initialize_by_lemma(DFLT_Props["phrase"]["lemma"])
  #TODO: Replace the next statement with  
  MyDPhrase.save
  #  !MyDPhrase.th_mod_info_id ? MyDPhrase.update_attribute(:th_mod_info_id , MyDModInfo.id) : nil #update (and save) if no th_mod_info exists yet. BTW, if th_mod_info_id is a DB required field, it's non-existence implies this is a newly formed object which should be saved and is by update_attribute.


  MyDDefinition = ThDefinition.find_or_initialize_by_definition(DFLT_Props["phrase"]["definition"])
  !MyDDefinition.th_mod_info_id ? MyDDefinition.update_attributes(:th_part_of_speech_id => MyDPartOfSpeech.id, :th_mod_info_id => MyDModInfo.id) : nil #update (and save) if no th_mod_info exists yet. BTW, if th_mod_info_id is a DB required field, it's non-existence implies this is a newly formed object which should be saved and is by update_attribute.

  MyDPhraseDefinition = ThPhraseDefinition.find_or_initialize_by_th_phrase_id_and_th_definition_id(MyDPhrase.id, MyDDefinition.id)
  !MyDPhraseDefinition.th_mod_info_id ? MyDPhraseDefinition.update_attribute(:th_mod_info_id, MyDModInfo.id) : nil #update (and save) if no th_mod_info exists yet. BTW, if th_mod_info_id is a DB required field, it's non-existence implies this is a newly formed object which should be saved and is by update_attribute.

  MyDMetaDataKey = ThMetadataKey.find_or_initialize_by_key(DFLT_Props["metadata"]["key"])
  !MyDMetaDataKey.description ? MyDMetaDataKey.update_attributes(:description => DFLT_Props["metadata"]["description"], :th_mod_info_id => MyDModInfo.id, :th_data_type_id  => MyDDataType.id) : nil #update (and save) if no description exists yet. BTW, if description is a DB required field, it's non-existence implies this is a newly formed object which should be saved and is by update_attribute.

  MyDMetaData = ThMetadatum.find_or_initialize_by_th_metadata_key_id(MyDMetaDataKey.id)
  !MyDMetaData.th_phrase_definition_id ? MyDMetaData.update_attributes(:th_phrase_definition_id => MyDPhraseDefinition.id, :value => DFLT_Props["metadata"]["value"]) : nil 

  MyDSortType = ThSortType.find_or_initialize_by_label(DFLT_Props["sorttype"]["label"])
  !MyDSortType.th_mod_info_id ? MyDSortType.update_attributes(:th_mod_info_id => MyDModInfo.id, :description => DFLT_Props["sorttype"]["descr"], :th_metadata_key_id => MyDMetaDataKey.id) : nil #update (and save) if no th_mod_info exists yet. BTW, if th_mod_info_id is a DB required field, it's non-existence implies this is a newly formed object which should be saved and is by update_attribute.

  MyDSortDirection = ThSortDirection.find_or_initialize_by_label(DFLT_Props["sortdirection"]["label"])
  !MyDSortDirection.th_mod_info_id ? MyDSortDirection.update_attributes(:th_mod_info_id => MyDModInfo.id, :description => DFLT_Props["sortdirection"]["descr"]) : nil #update (and save) if no th_mod_info exists yet. BTW, if th_mod_info_id is a DB required field, it's non-existence implies this is a newly formed object which should be saved and is by update_attribute.

  MyDSortTypeDirection = ThSortTypeDirection.find_or_initialize_by_th_sort_type_id(MyDSortType.id)
  !MyDSortTypeDirection.th_sort_direction_asc_id ? MyDSortTypeDirection.update_attributes(:th_sort_direction_asc_id => MyDSortDirection.id, :th_sort_direction_desc_id => MyDSortDirection.id) : nil #update (and save) if no th_sort_direction_XXX_id exists yet. BTW, if th_sort_direction_XXX_id is a DB required field, it's non-existence implies this is a newly formed object which should be saved and is by update_attribute.

  MyDOrdinality = DFLT_Props["ordinality"] 

  #Parts of Speech
  ADJ = ThPartOfSpeech.where{name.eq 'adjective'}.first.th_part_of_speech_id
  ADV = ThPartOfSpeech.where{name.eq 'adverb'}.first.th_part_of_speech_id
  CONJ = ThPartOfSpeech.where{name.eq 'conjunction'}.first.th_part_of_speech_id
  INTRJ = ThPartOfSpeech.where{name.eq 'interjection'}.first.th_part_of_speech_id
  NOUN = ThPartOfSpeech.where{name.eq 'noun'}.first.th_part_of_speech_id
  PREP = ThPartOfSpeech.where{name.eq 'preposition'}.first.th_part_of_speech_id
  PRON = ThPartOfSpeech.where{name.eq 'pronoun'}.first.th_part_of_speech_id
  VERB = ThPartOfSpeech.where{name.eq 'verb'}.first.th_part_of_speech_id
  ADJSAT = ThPartOfSpeech.where{name.eq 'adjective_satellite'}.first.th_part_of_speech_id

  #Ordinalities 
  PRIMARY_ORD = 1
  SIMILARS_ORD = 2
  ANTONYMS_ORD = 3

  #Group Num Defaults
  UNSPECIFIED_1 = -111111
  UNSPECIFIED_2 = -222222
  UNSPECIFIED_3 = -333333
  UNSPECIFIED_4 = -444444
  UNSPECIFIED_5 = -555555
end #module 
