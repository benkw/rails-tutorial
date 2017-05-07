#Define a user variable using the fixtures.
#Call the remember method to remember the given user.
#Verify that current_user is equal to the given user.

require 'test_helper'

class SessionsHelperTest <ActionView::TestCase
  
  def setup
    @user = users(:michael)
    remember(@user)
  end
  
  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    # conventional order is to assert_equal <expected>, <actual>
    assert is_logged_in?
  end
  
  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user # this tests the authenticared? expression in the nested if statement if user %% user.authenticated?(cookies[:remember_token])
  end
  
end