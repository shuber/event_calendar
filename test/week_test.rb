require 'test_helper'

class WeekTest < Test::Unit::TestCase

  context 'an EventCalendar::Week' do
    setup do 
      @week_start = Date.civil(2009, 10, 4)
      @week_end = Date.civil(2009, 10, 10)
      @days = (@week_start..@week_end).to_a
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
        ].collect { |event| EventCalendar::Event.new(event, EventCalendar.default_options) }
      end
      @week = EventCalendar::Week.new(@days, @events)
    end
    
    should 'should add associated events to days' do
      @days.each_with_index do |day, index|
        events = @events.select { |event| event.start_date == day || (event.start_date < day && event.end_date >= day && day == @days.first) }
        assert_equal events, @week[index].events
      end
    end
  end
  
end