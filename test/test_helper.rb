require "coveralls"
require "minitest/reporters"

Coveralls.wear!
Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "xambassador"
require "minitest/autorun"
