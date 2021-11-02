require 'test_helper'

class LikeMailerTest < ActionMailer::TestCase
  test "creation_like" do
    mail = LikeMailer.creation_like
    assert_equal "Creation like", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
