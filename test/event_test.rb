require 'test_helper'

class EventTest < Test::Unit::TestCase

  context 'an EventCalendar::Event' do
    setup do 
      @event_title = 'testing'
      @start_time = Time.local(2010, 1, 3, 10, 5, 0)
      @end_time = Time.local(2010, 1, 5, 11, 35, 0)
      @raw_event = Event.new(@event_title, @start_time, @end_time)
      @event = EventCalendar::Event.new(@raw_event, EventCalendar.default_options.merge({
        :event_title_symbol => :title, 
        :event_title_string => 'string', 
        :event_title_proc   => proc { |event| event.title + '_proc' }
      }))
    end
    
    should 'have a start_date' do
      assert_equal @start_time.to_date, @event.start_date
    end
    
    should 'have an end_date' do
      assert_equal @end_time.to_date, @event.end_date
    end
    
    should 'return the number of days it spans' do
      assert_equal 3, @event.days
    end
    
    should 'return the number of days it spans with a starting week offset' do
      assert_equal 2, @event.days(@event.start_date + 1.day)
    end
    
    should 'return the number of days it spans with an ending week offset' do
      assert_equal 2, @event.days(@event.start_date, @event.end_date - 1.day)
    end
    
    should 'return the number of days it spans with a starting and ending week offset' do
      assert_equal 1, @event.days(@event.start_date + 1.day, @event.end_date - 1.day)
    end
    
    should 'evaluate missing attributes as symbols' do
      assert_equal @event_title, @event.title_symbol
    end
    
    should 'evaluate missing attributes as objects' do
      assert_equal 'string', @event.title_string
    end
    
    should 'evaluate missing attributes as procs and pass the raw event' do
      assert_equal @event_title + '_proc', @event.title_proc
    end
    
    should 'delegate all other missing attributes to the raw event' do
      assert_equal @raw_event.id, @event.id
    end
  end
  
end