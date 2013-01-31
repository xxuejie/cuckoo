require 'digest/md5'
require 'uri'

module Helpers
  def self.encode_uri(str)
    URI.escape(str)
  end

  def self.normalize_avatar_url(avatar)
    if avatar.nil? || avatar.length == 0
      return "http://www.gravatar.com/avatar/00000000000000000000000000000000"
    end

    if avatar.index('@')
      # email address
      "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(avatar)}"
    else
      avatar
    end
  end
end
