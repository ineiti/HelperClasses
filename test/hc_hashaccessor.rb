require 'test/unit'

class TC_Arraysym < Test::Unit::TestCase

  def setup
  end

  def test_simple
    a = {}
    a._hi = 'there'
    assert_equal 'there', a[:hi]
  end

  def test_replace
    a = {'one' => 1, two: 2}
    assert_equal 1, a._one
    assert_equal 2, a._two

    a._one = 3
    a._two = 4
    assert_equal 3, a._one
    assert_equal 4, a._two
    assert_equal ['one', :two], a.keys
  end
end
