require 'ohm'

class Tweet < Ohm::Model
  reference :user, :User

  attribute :content
  attribute :time

  def validate
    assert_present :content
    assert_present :time
    assert_present :user
  end
end
