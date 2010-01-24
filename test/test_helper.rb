require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'timecop'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'event_calendar'

class Test::Unit::TestCase
  
  def events
    Timecop.freeze(Date.civil(2009, 10, 6)) do
      @events ||= [
        Event.new('Event 1', Time.now, 10.minutes.from_now),
        Event.new('Event 1a', Time.now, 10.minutes.from_now),
        Event.new('Event 1b', Time.now, 10.minutes.from_now),
        Event.new('Event 1c', Time.now, 10.minutes.from_now),
        Event.new('Event 2', 1.day.from_now, 1.5.days.from_now),
        Event.new('Event 3', Time.now, 3.days.from_now),
        Event.new('Event 4 has a longer title', 3.days.from_now, 5.days.from_now),
        Event.new('Event 5 spans across multiple weeks', 4.days.from_now, 12.days.from_now)
      ]
    end
    @events
  end
  
  def fixtures_path
    File.join(File.dirname(__FILE__), 'fixtures')
  end
  
end

Event = Struct.new(:title, :starts_at, :ends_at) do
  def id; object_id; end
end