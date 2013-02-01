require 'spec_helper'

describe "User model" do
  before(:each) do
    Ohm.flush
  end

  it "should be able to create a new one" do
    u = User.create({login_name: "new_user",
                      description: "desc",
                      avatar: "http://www.gravatar.com/avatar/55502F40DC8B7C769880B10874ABC9D0",
                      hashed_password: "pass",
                      salt: "salt"})
    expect(u).to_not be_nil
    expect(u.login_name).to eq("new_user")
    expect(u.description).to eq("desc")
    expect(u.avatar).to eq("http://www.gravatar.com/avatar/55502F40DC8B7C769880B10874ABC9D0")
    expect(u.tweets).to_not be_nil
    expect(u.tweets.size).to be(0)
  end

  it "should at least have a login name" do
    expect(User.create).to be_nil
  end

  it "should not be able to create 2 users with same name" do
    User.create({login_name: "aname",
                  hashed_password: "pass",
                  salt: "salt"})
    expect {
      User.create({login_name: "aname",
                    hashed_password: "pass",
                    salt: "salt"})
    }.to raise_error(Ohm::UniqueIndexViolation)
  end

  it "should not be able to create user without password" do
    expect(User.create({login_name: "aname", salt: "salt"})).to be_nil
  end

  it "should not be able to create user without salt" do
    expect(User.create({login_name: "aname", hashed_password: "pass"})).to be_nil
  end

  describe "authentication tests" do
    before(:each) do
      @login_name = "aname"
      @pass = "pass"
      @salt = "salt"
      @wrong_pass = "123"
      @not_exist_login_name = "wrongname"
      User.create({login_name: @login_name,
                    hashed_password: @pass + @salt,
                    salt: @salt})

      # monkey patch encrypt_password here
      module Helpers
        module Authentication
          alias_method :origin_encrypt, :encrypt_password

          def encrypt_password(pass, salt)
            pass + salt
          end
        end
      end
    end

    after(:each) do
      # Restore monkey patched function
      module Helpers
        module Authentication
          alias_method :encrypt_password, :origin_encrypt
          remove_method :origin_encrypt
        end
      end
    end

    it "should be able to login with right password" do
      expect(User.authenticate(@login_name, @pass)).to_not be_nil
    end

    it "should not be able to login with wrong password" do
      expect(User.authenticate(@login_name, @wrong_pass)).to be_nil
    end

    it "should not be able to login with login name that does not exist" do
      expect(User.authenticate(@not_exist_login_name, @pass)).to be_nil
    end

    it "should raise error when creating a new one without login name" do
      lambda {
        User.create_with_check({password: @pass})
      }.should raise_error(ArgumentError)
    end

    it "should raise error when creating a new user without password" do
      lambda {
        User.create_with_check({login_name: @not_exist_login_name})
      }.should raise_error(ArgumentError)
    end

    it "should raise error when creating a user with same name" do
      lambda {
        User.create_with_check({login_name: @login_name, password: @pass})
      }.should raise_error(ArgumentError)
    end

    it "should not be able to update user with same name" do
      u = User.create({login_name: @not_exist_login_name,
                        hashed_password: @pass + @salt,
                        salt: @salt})
      lambda {
        u.update_with_check({login_name: @login_name})
      }.should raise_error(ArgumentError)
    end

    it "should be able to update user information" do
      u = User.find({login_name: @login_name}).first
      u.update_with_check({login_name: @not_exist_login_name,
                            password: @wrong_pass})

      expect(User.find({login_name: @login_name}).size).to be(0)
      u = User.find({login_name: @not_exist_login_name}).first

      expect(u.login_name).to eq(@not_exist_login_name)
      expect(u.hashed_password).to eq(@wrong_pass + @salt)
    end
  end
end
