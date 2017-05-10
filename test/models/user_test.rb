require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                        password: "foobar", password_confirmation: "foobar")
  end
  
  test "should be valid" do
    assert @user.valid?
  end

  test "name should not be blank" do
    @user.name = "     "
    assert_not @user.valid?
  end
  
  test "email should not be blank" do
    @user.email = "     "
    assert_not @user.valid?
  end
  
  test "user name cannot be longer than 50 characters" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  test "email cannot be longer than 255 characters" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
  
  test "email validations should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar first.last@foo.jp alice+bob@baz.cn]
    
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validations should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo.bar@gmail..com]
 
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email.upcase!
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email addresses should be saved as lower case" do
    mixed_case_email = "Foo@EXAMple.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "passwords should be present" do
    @user.password = @user.password_confirmation = "   "
    assert_not @user.valid?
  end
  
  test "password should be 6 characters minimum" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, ' ')
  end
  
end
