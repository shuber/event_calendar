require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'timecop'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'event_calendar'

class Test::Unit::TestCase
end

Event = Struct.new(:title, :starts_at, :ends_at) do
  def id; object_id; end
end