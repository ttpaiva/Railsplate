require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :email => "example@example.com", :password => "test123", :password_confirmation => "test123"}
  end

  it "should create a new user given valid arguments" do
    correct_user = User.create!(@attr)
    correct_user.should be_valid
  end

  it "should not create a new user given invalid arguments" do
    invalid_user = User.new(@attr.merge(:email => ""))
    invalid_user.should_not be_valid
  end


  describe "e-mail validations" do
    it "should reject invalid email addresses" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.] 
      addresses.each do |address|
        invalid_email_user = User.new(@attr.merge(:email => address))
        invalid_email_user.should_not be_valid 
      end
    end

    it "should reject duplicate email addresses" do
      User.create!(@attr)
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end

    it "should reject email addresses identical up to case" do
      upcased_email = @attr[:email].upcase 
      User.create!(@attr.merge(:email => upcased_email)) 
      user_with_duplicate_email = User.new(@attr) 
      user_with_duplicate_email.should_not be_valid
    end
  end

  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long passwords" do
      long = "a" * 41 
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end
  end
  
  # describe "subscription information" do
  #    before(:each) do
  #      @user = User.create!(@attr)
  #    end
  #    
  #    it "should have a plan field" do
  #      @user.should respond_to(:plan)
  #    end
  #    
  #    it "should have a plan field with data" do
  #      @user.plan.should_not be_nil
  #      @user.plan.should_not be_empty
  #    end
  #  end
end
