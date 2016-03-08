require 'test_helper'

# Renegade tests
class XambassadorTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Xambassador::VERSION
  end
end
