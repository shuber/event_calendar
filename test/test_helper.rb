require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'timecop'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'event_calendar'

class Test::Unit::TestCase
end