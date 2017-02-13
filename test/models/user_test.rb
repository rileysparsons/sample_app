require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end


  def setup
  	@user = User.new(name: "Example", email: "riley.s.parsons@gmail.com", password:"password", password_confirmation:"password")
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be present" do
  	@user.name = "   "
  	assert_not @user.valid?
  end

  test "email should be present" do
  	@user.email = "   "
  	assert_not @user.valid?
  end

  test "name should not be too long" do
  	@user.name = "test"*80
  	assert_not @user.valid?
  end

  test "email should not be too long" do
  	@user.email = "email"*80
  	assert_not @user.valid?
  end

  test "valid email addresses should be valid" do
  	valid_addresses = %w[user@example.com USER@foo.com A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
  	valid_addresses.each do |valid_address|
  		@user.email = valid_address
  		assert @user.valid?
  	end
  end

  test "invalid email addresses should not be valid" do
  	invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com user_at_foo..org]
  	invalid_addresses.each do |invalid_address|
  		@user.email = invalid_address
  		assert_not @user.valid?, "#{invalid_address} should not be valid"
  	end
  end

  test "email address should be unique" do
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "emails should be standardized to lowercase before save" do
  	mixed_case_email = "test@GMaiL.CoM"
  	@user.email = mixed_case_email
  	@user.save
  	assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should have a minimum length" do
  	@user.password = "a" * 5
  	@user.password_confirmation = @user.password
  	assert_not @user.valid?
  end

end
