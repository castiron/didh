require 'test_helper'

class PartsControllerTest < ActionController::TestCase
  setup do
    @part = parts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:parts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create part" do
    assert_difference('Part.count') do
      post :create, part: { label: @part.label }
    end

    assert_redirected_to part_path(assigns(:part))
  end

  test "should show part" do
    get :show, id: @part
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @part
    assert_response :success
  end

  test "should update part" do
    put :update, id: @part, part: { label: @part.label }
    assert_redirected_to part_path(assigns(:part))
  end

  test "should destroy part" do
    assert_difference('Part.count', -1) do
      delete :destroy, id: @part
    end

    assert_redirected_to parts_path
  end
end
