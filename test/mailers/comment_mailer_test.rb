require 'test_helper'

class CommentMailerTest < ActionMailer::TestCase
  test "creation_comment" do
    mail = CommentMailer.creation_comment
    assert_equal "Creation comment", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
