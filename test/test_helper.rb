require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'timecop'

require 'active_support'
require 'markaby'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'calendar'

class Test::Unit::TestCase
end