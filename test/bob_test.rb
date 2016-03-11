require "test_helper"

# Xambassador tests
class XambassadorTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Xambassador::VERSION
  end
end
