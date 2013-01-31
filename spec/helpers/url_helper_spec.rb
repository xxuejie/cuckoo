require 'spec_helper'

describe "url helper" do
  include Helpers::Url

  it "should encode a URI" do
    original_str = "#q=12&d=a+b\nc\""
    encoded_str = "%23q=12&d=a+b%0Ac%22"
    expect(encode_uri original_str).to eq(encoded_str)
  end

  it "should normalize email into gravatar url" do
    email = "test@example.com"
    avatar = "http://www.gravatar.com/avatar/55502F40DC8B7C769880B10874ABC9D0"

    expect(normalize_avatar_url "test@example.com").to eq(avatar)
  end

  it "should not change avatar which is already an url" do
    avatar = "http://www.gravatar.com/avatar/00000000000000000000000000000000"

    expect(normalize_avatar_url avatar).to eq(avatar)
  end
end
