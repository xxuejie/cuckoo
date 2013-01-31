require 'spec_helper'

describe "authentication helper" do
  it "should generate a non-empty salt" do
    salt = Helpers::generate_salt

    expect(salt).to_not be_nil
    expect(salt.length).to_not be(0)
  end

  it "should encrpy a password, the original password should not be in the encrypted one" do
    pass = "pass"
    salt = "salt"
    hashed_password = Helpers::encrypt_password(pass, salt)

    expect(hashed_password).to_not be_nil
    expect(hashed_password.length).to_not be(0)
    expect(hashed_password.index(pass)).to be_nil
    expect(hashed_password.index(salt)).to be_nil
  end
end
