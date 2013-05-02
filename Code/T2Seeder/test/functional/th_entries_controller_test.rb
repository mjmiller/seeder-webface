require 'test_helper'

class ThEntriesControllerTest < ActionController::TestCase
  setup do
    @th_entry = th_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:th_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create th_entry" do
    assert_difference('ThEntry.count') do
      post :create, th_entry: { : @th_entry., th_entry_id: @th_entry.th_entry_id, th_mod_info: @th_entry.th_mod_info, th_sequence_default_id: @th_entry.th_sequence_default_id, title: @th_entry.title }
    end

    assert_redirected_to th_entry_path(assigns(:th_entry))
  end

  test "should show th_entry" do
    get :show, id: @th_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @th_entry
    assert_response :success
  end

  test "should update th_entry" do
    put :update, id: @th_entry, th_entry: { : @th_entry., th_entry_id: @th_entry.th_entry_id, th_mod_info: @th_entry.th_mod_info, th_sequence_default_id: @th_entry.th_sequence_default_id, title: @th_entry.title }
    assert_redirected_to th_entry_path(assigns(:th_entry))
  end

  test "should destroy th_entry" do
    assert_difference('ThEntry.count', -1) do
      delete :destroy, id: @th_entry
    end

    assert_redirected_to th_entries_path
  end
end
