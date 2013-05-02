require 'test_helper'

class SeederStatusesControllerTest < ActionController::TestCase
  setup do
    @seeder_status = seeder_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:seeder_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create seeder_status" do
    assert_difference('SeederStatus.count') do
      post :create, seeder_status: { group_num: @seeder_status.group_num, offset: @seeder_status.offset, pos: @seeder_status.pos }
    end

    assert_redirected_to seeder_status_path(assigns(:seeder_status))
  end

  test "should show seeder_status" do
    get :show, id: @seeder_status
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @seeder_status
    assert_response :success
  end

  test "should update seeder_status" do
    put :update, id: @seeder_status, seeder_status: { group_num: @seeder_status.group_num, offset: @seeder_status.offset, pos: @seeder_status.pos }
    assert_redirected_to seeder_status_path(assigns(:seeder_status))
  end

  test "should destroy seeder_status" do
    assert_difference('SeederStatus.count', -1) do
      delete :destroy, id: @seeder_status
    end

    assert_redirected_to seeder_statuses_path
  end
end
