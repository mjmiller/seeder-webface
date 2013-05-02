# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130501191526) do

  create_table "ontol_tool_kit_types", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.integer  "ontolToolKitParentId"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "ontol_tool_kits", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "ontologyId"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "version"
    t.integer  "otk_type"
  end

  create_table "ontologies", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "ontology_type"
    t.string   "location"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "version"
    t.string   "classname"
  end

  create_table "ontology_types", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.integer  "ontologyTypeParentId"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "seeder_status2s", :force => true do |t|
    t.integer  "pos"
    t.integer  "group_num"
    t.integer  "offset"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "seeder_statuses", :force => true do |t|
    t.integer  "pos"
    t.integer  "group_num"
    t.integer  "offset"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "synset_t2_maps", :force => true do |t|
    t.integer  "synset_id"
    t.integer  "th_phrase_definition_id"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.integer  "th_sequence_id"
    t.boolean  "primaries_sequenced",     :default => false, :null => false
    t.boolean  "similars_sequenced",      :default => false, :null => false
    t.boolean  "antonyms_sequenced",      :default => false, :null => false
    t.integer  "group_num",               :default => 0
  end

  create_table "th_algorithm", :primary_key => "th_algorithm_id", :force => true do |t|
    t.string "name",        :limit => 50,   :null => false
    t.string "description", :limit => 1000, :null => false
  end

  add_index "th_algorithm", ["th_algorithm_id"], :name => "th_algorithm_id"

  create_table "th_data_type", :primary_key => "th_data_type_id", :force => true do |t|
    t.string "name",        :limit => 20,   :null => false
    t.string "description", :limit => 1000, :null => false
  end

  create_table "th_definition", :primary_key => "th_definition_id", :force => true do |t|
    t.string  "definition",           :limit => 2000, :null => false
    t.integer "th_mod_info_id",                       :null => false
    t.integer "th_part_of_speech_id"
  end

  add_index "th_definition", ["th_mod_info_id"], :name => "th_mod_info_id"
  add_index "th_definition", ["th_part_of_speech_id"], :name => "fk_th_definition_th_part_of_speech1_idx"

  create_table "th_domain", :primary_key => "th_domain_id", :force => true do |t|
    t.string "name",        :limit => 50,   :null => false
    t.string "description", :limit => 1000, :null => false
  end

  create_table "th_editor_action", :primary_key => "th_editor_action_id", :force => true do |t|
    t.string "name",        :limit => 50,   :null => false
    t.string "description", :limit => 1000, :null => false
  end

  create_table "th_entry", :primary_key => "th_entry_id", :force => true do |t|
    t.string  "title",                  :limit => 200,  :null => false
    t.string  "description",            :limit => 1000, :null => false
    t.integer "th_sequence_default_id"
    t.integer "th_mod_info_id",                         :null => false
  end

  add_index "th_entry", ["th_mod_info_id"], :name => "th_mod_info_id"
  add_index "th_entry", ["th_sequence_default_id"], :name => "th_sequence_default_id"

  create_table "th_entry_label", :primary_key => "th_entry_label_id", :force => true do |t|
    t.integer   "th_entry_id",                    :null => false
    t.string    "name",           :limit => 50,   :null => false
    t.string    "description",    :limit => 1000, :null => false
    t.integer   "th_mod_info_id",                 :null => false
    t.timestamp "label_datetime",                 :null => false
  end

  add_index "th_entry_label", ["th_entry_id"], :name => "th_entry_id"
  add_index "th_entry_label", ["th_mod_info_id"], :name => "th_mod_info_id"

  create_table "th_entry_sequence", :primary_key => "th_entry_sequence_id", :force => true do |t|
    t.integer "th_entry_id",    :null => false
    t.integer "th_sequence_id", :null => false
  end

  add_index "th_entry_sequence", ["th_entry_id"], :name => "th_entry_id"
  add_index "th_entry_sequence", ["th_entry_sequence_id"], :name => "th_entry_sequence_id", :unique => true
  add_index "th_entry_sequence", ["th_sequence_id"], :name => "th_sequence_id"

  create_table "th_example", :primary_key => "th_example_id", :force => true do |t|
    t.integer "th_definition_id",                :null => false
    t.integer "th_mod_info_id",                  :null => false
    t.string  "example",          :limit => 100, :null => false
    t.integer "ordinality",                      :null => false
  end

  add_index "th_example", ["th_definition_id"], :name => "th_definition_id"
  add_index "th_example", ["th_mod_info_id"], :name => "th_mod_info_id"

  create_table "th_member", :primary_key => "th_member_id", :force => true do |t|
    t.integer "th_sequence_id",          :null => false
    t.integer "th_phrase_definition_id", :null => false
    t.integer "ordinality",              :null => false
    t.integer "th_mod_info_id",          :null => false
  end

  add_index "th_member", ["th_mod_info_id"], :name => "th_mod_info_id"
  add_index "th_member", ["th_phrase_definition_id"], :name => "th_phrase_definition_id"
  add_index "th_member", ["th_sequence_id"], :name => "th_sequence_id"

  create_table "th_metadata", :primary_key => "th_metadata_id", :force => true do |t|
    t.integer "th_phrase_definition_id",                 :null => false
    t.integer "th_metadata_key_id",                      :null => false
    t.string  "value",                   :limit => 1000, :null => false
  end

  add_index "th_metadata", ["th_metadata_key_id"], :name => "th_metadata_key_id"
  add_index "th_metadata", ["th_phrase_definition_id"], :name => "th_phrase_definition_id"

  create_table "th_metadata_key", :primary_key => "th_metadata_key_id", :force => true do |t|
    t.string  "key",             :limit => 100,  :null => false
    t.string  "description",     :limit => 1000, :null => false
    t.integer "th_mod_info_id",                  :null => false
    t.integer "th_data_type_id",                 :null => false
  end

  add_index "th_metadata_key", ["th_data_type_id"], :name => "fk_th_metadata_key_th_data_type1_idx"
  add_index "th_metadata_key", ["th_mod_info_id"], :name => "th_mod_info_id"

  create_table "th_mod_info", :primary_key => "th_mod_info_id", :force => true do |t|
    t.integer   "th_source_id",        :null => false
    t.integer   "th_editor_action_id", :null => false
    t.timestamp "mod_datetime",        :null => false
  end

  add_index "th_mod_info", ["th_editor_action_id"], :name => "th_editor_action_id"
  add_index "th_mod_info", ["th_source_id", "th_editor_action_id"], :name => "th_source_id"

  create_table "th_part_of_speech", :primary_key => "th_part_of_speech_id", :force => true do |t|
    t.string "name", :limit => 30, :null => false
    t.string "abbr", :limit => 10, :null => false
  end

  create_table "th_phrase", :primary_key => "th_phrase_id", :force => true do |t|
    t.string "lemma", :limit => 100, :null => false
  end

  create_table "th_phrase_definition", :primary_key => "th_phrase_definition_id", :force => true do |t|
    t.integer "th_phrase_id",     :null => false
    t.integer "th_definition_id", :null => false
    t.integer "th_mod_info_id",   :null => false
  end

  add_index "th_phrase_definition", ["th_definition_id"], :name => "th_definition_id"
  add_index "th_phrase_definition", ["th_mod_info_id"], :name => "th_mod_info_id"
  add_index "th_phrase_definition", ["th_phrase_id"], :name => "th_phrase_id"

  create_table "th_sequence", :primary_key => "th_sequence_id", :force => true do |t|
    t.integer "th_sort_type_direction_id", :null => false
    t.integer "th_mod_info_id",            :null => false
    t.integer "th_part_of_speech_id"
  end

  add_index "th_sequence", ["th_mod_info_id"], :name => "th_mod_info_id"
  add_index "th_sequence", ["th_part_of_speech_id"], :name => "fk_th_sequence_th_part_of_speech1_idx"
  add_index "th_sequence", ["th_sort_type_direction_id"], :name => "th_sort_type_direction_id"

  create_table "th_sort_direction", :primary_key => "th_sort_direction_id", :force => true do |t|
    t.string  "label",          :limit => 100,  :null => false
    t.string  "description",    :limit => 1000, :null => false
    t.integer "th_mod_info_id",                 :null => false
  end

  add_index "th_sort_direction", ["th_mod_info_id"], :name => "th_mod_info_id"

  create_table "th_sort_type", :primary_key => "th_sort_type_id", :force => true do |t|
    t.string  "label",              :limit => 100,  :null => false
    t.string  "description",        :limit => 1000, :null => false
    t.integer "th_mod_info_id",                     :null => false
    t.integer "th_metadata_key_id"
  end

  add_index "th_sort_type", ["th_metadata_key_id"], :name => "th_sort_type_ibfk_2_idx"
  add_index "th_sort_type", ["th_mod_info_id"], :name => "th_mod_info_id"

  create_table "th_sort_type_direction", :primary_key => "th_sort_type_direction_id", :force => true do |t|
    t.integer "th_sort_type_id",           :null => false
    t.integer "th_sort_direction_asc_id",  :null => false
    t.integer "th_sort_direction_desc_id", :null => false
  end

  add_index "th_sort_type_direction", ["th_sort_direction_asc_id"], :name => "th_sort_direction_id"
  add_index "th_sort_type_direction", ["th_sort_direction_desc_id"], :name => "th_sort_type_direction_ibfk_2_idx"
  add_index "th_sort_type_direction", ["th_sort_type_id"], :name => "th_sort_type_id"

  create_table "th_source", :primary_key => "th_source_id", :force => true do |t|
    t.integer "th_source_type_id", :null => false
    t.integer "th_user_id",        :null => false
    t.integer "th_algorithm_id"
    t.integer "external_ref_id"
  end

  add_index "th_source", ["th_algorithm_id"], :name => "th_algorithm_id"
  add_index "th_source", ["th_source_type_id"], :name => "th_source_type_id"
  add_index "th_source", ["th_user_id"], :name => "th_user_id"

  create_table "th_source_type", :primary_key => "th_source_type_id", :force => true do |t|
    t.string "name",        :limit => 50,   :null => false
    t.string "description", :limit => 1000, :null => false
  end

  create_table "th_thesortus", :primary_key => "th_thesortus_id", :force => true do |t|
    t.integer "th_thesortus_parent_id"
    t.integer "th_domain_id",           :null => false
    t.integer "th_mod_info_id"
  end

  add_index "th_thesortus", ["th_domain_id"], :name => "th_domain_id"
  add_index "th_thesortus", ["th_mod_info_id"], :name => "th_mod_info_id"
  add_index "th_thesortus", ["th_thesortus_parent_id"], :name => "th_thesortus_parent_id"

  create_table "th_thesortus_entry", :primary_key => "th_thesortus_entry_id", :force => true do |t|
    t.integer "th_thesortus_id", :null => false
    t.integer "th_entry_id",     :null => false
  end

  add_index "th_thesortus_entry", ["th_entry_id"], :name => "th_entry_id"
  add_index "th_thesortus_entry", ["th_thesortus_id"], :name => "th_thesortus_id"

  create_table "th_user", :primary_key => "th_userId", :force => true do |t|
    t.integer "cms_user_id",                    :null => false
    t.boolean "is_deleted",  :default => false, :null => false
  end

  add_index "th_user", ["cms_user_id"], :name => "cms_user_id"

end
