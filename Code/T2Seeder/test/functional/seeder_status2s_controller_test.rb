require 'test_helper'

class SeederStatus2sControllerTest < ActionController::TestCase
  setup do
    @seeder_status2 = seeder_status2s(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:seeder_status2s)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create seeder_status2" do
    assert_difference('SeederStatus2.count') do
      post :create, seeder_status2: { group_num: @seeder_status2.group_num, offset: @seeder_status2.offset, pos: @seeder_status2.pos }
    end

    assert_redirected_to seeder_status2_path(assigns(:seeder_status2))
  end

  test "should show seeder_status2" do
    get :show, id: @seeder_status2
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @seeder_status2
    assert_response :success
  end

  test "should update seeder_status2" do
    put :update, id: @seeder_status2, seeder_status2: { group_num: @seeder_status2.group_num, offset: @seeder_status2.offset, pos: @seeder_status2.pos }
    assert_redirected_to seeder_status2_path(assigns(:seeder_status2))
  end

  test "should destroy seeder_status2" do
    assert_difference('SeederStatus2.count', -1) do
      delete :destroy, id: @seeder_status2
    end

    assert_redirected_to seeder_status2s_path
  end
end
