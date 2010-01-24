require 'test_helper'

class WeekTest < Test::Unit::TestCase

  context 'an EventCalendar::Week' do
    setup do 
      @week_start = Date.civil(2009, 10, 4)
      @week_end = Date.civil(2009, 10, 10)
      @days = (@week_start..@week_end).to_a
      @events = events.collect { |event| EventCalendar::Event.new(event, EventCalendar.default_options) }
      @week = EventCalendar::Week.new(@days, @events)
    end
    
    should 'should add associated events to days' do
      @days.each_with_index do |day, index|
        events = @events.select { |event| event.start_date == day || (event.start_date < day && event.end_date >= day && day == @days.first) }
        assert_equal events, @week[index].events
      end
    end
    
    should 'correctly parse events into calendar week rows containing hashes' do
      @parsed_events = [
        [{}, {}, { :event => @events[0], :span => 1, :continued => false }, { :event => @events[4], :span => 1, :continued => false}, {}, { :event => @events[6], :span => 2, :continued => true }],
        [{}, {}, { :event => @events[1], :span => 1, :continued => false }, {}, {}, {}, { :event => @events[7], :span => 1, :continued => true }],
        [{}, {}, { :event => @events[2], :span => 1, :continued => false }, {}, {}, {}, {}],
        [{}, {}, { :event => @events[3], :span => 1, :continued => false }, {}, {}, {}, {}],
        [{}, {}, { :event => @events[5], :span => 4, :continued => false }, {}]
      ]
      assert_equal @parsed_events, @week.events
    end
  end
  
end