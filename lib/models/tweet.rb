require 'ohm'

class Tweet < Ohm::Model
  reference :user, :User

  attribute :content
  attribute :time
end
