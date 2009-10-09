require 'test_helper'

Event = Struct.new(:title, :starts_at, :ends_at) do
  def id; object_id; end
end

class CalendarTest < Test::Unit::TestCase

  should 'print out a calender' do
    Timecop.freeze(Date.civil(2009, 10, 6)) do
      events = [
        Event.new('Event 1', Time.now, 10.minutes.from_now),
        Event.new('Event 1a', Time.now, 10.minutes.from_now),
        Event.new('Event 1b', Time.now, 10.minutes.from_now),
        Event.new('Event 1c', Time.now, 10.minutes.from_now),
        Event.new('Event 2', 1.day.from_now, 1.5.days.from_now),
        Event.new('Event 3', Time.now, 3.days.from_now),
        Event.new('Event 4 has a longer title', 3.days.from_now, 5.days.from_now),
        Event.new('Event 5 spans across multiple weeks', 4.days.from_now, 12.days.from_now)
      ]
      
      c = Calendar.new(Time.now.year, Time.now.month, :events => events)
      puts c.to_html
    end
  end
  
end