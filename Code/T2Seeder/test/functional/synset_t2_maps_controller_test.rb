require 'test_helper'

class SynsetT2MapsControllerTest < ActionController::TestCase
  setup do
    @synset_t2_map = synset_t2_maps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:synset_t2_maps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create synset_t2_map" do
    assert_difference('SynsetT2Map.count') do
      post :create, synset_t2_map: { antonyms_sequenced: @synset_t2_map.antonyms_sequenced, group_num: @synset_t2_map.group_num, primaries_sequenced: @synset_t2_map.primaries_sequenced, similars_sequenced: @synset_t2_map.similars_sequenced, synset_id: @synset_t2_map.synset_id, th_phrase_definition_id: @synset_t2_map.th_phrase_definition_id, th_sequence_id: @synset_t2_map.th_sequence_id }
    end

    assert_redirected_to synset_t2_map_path(assigns(:synset_t2_map))
  end

  test "should show synset_t2_map" do
    get :show, id: @synset_t2_map
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @synset_t2_map
    assert_response :success
  end

  test "should update synset_t2_map" do
    put :update, id: @synset_t2_map, synset_t2_map: { antonyms_sequenced: @synset_t2_map.antonyms_sequenced, group_num: @synset_t2_map.group_num, primaries_sequenced: @synset_t2_map.primaries_sequenced, similars_sequenced: @synset_t2_map.similars_sequenced, synset_id: @synset_t2_map.synset_id, th_phrase_definition_id: @synset_t2_map.th_phrase_definition_id, th_sequence_id: @synset_t2_map.th_sequence_id }
    assert_redirected_to synset_t2_map_path(assigns(:synset_t2_map))
  end

  test "should destroy synset_t2_map" do
    assert_difference('SynsetT2Map.count', -1) do
      delete :destroy, id: @synset_t2_map
    end

    assert_redirected_to synset_t2_maps_path
  end
end
