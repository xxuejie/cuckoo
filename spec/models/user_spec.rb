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

  describe "login feature" do
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
        class << self
          alias_method :origin_encrypt, :encrypt_password
        end

        def self.encrypt_password(pass, salt)
          pass + salt
        end
      end
    end

    after(:each) do
      # Restore monkey patched function
      module Helpers
        class << self
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
  end
end
