require 'test_helper'

class EventCalendarTest < Test::Unit::TestCase

  context 'an EventCalendar instance' do
    setup do
      Timecop.freeze(Date.civil(2009, 10, 6)) do
        @event_calendar = EventCalendar.new(Time.now.year, Time.now.month, 
          :events => events,
          :date_format_string => '%B',
          :date_format_symbol => :year,
          :date_format_proc => proc { |date| date.year },
          :date_format_integer => 2009
        )
      end
    end
    
    should 'return the first day of its specified month and year when calling date' do
      assert_equal Date.civil(2009, 10, 1), @event_calendar.date
    end
    
    context 'when calling evaluate_date_format_option it' do
      setup { @date = @event_calendar.date }
      
      should 'evaluate strings' do
        assert_equal @date.strftime('%B'), @event_calendar.evaluate_date_format_option(:date_format_string, @date)
      end
      
      should 'evaluate symbols' do
        assert_equal @date.year, @event_calendar.evaluate_date_format_option(:date_format_symbol, @date)
      end
      
      should 'evaluate procs' do
        assert_equal @date.year, @event_calendar.evaluate_date_format_option(:date_format_proc, @date)
      end
      
      should 'return all other values' do
        assert_equal 2009, @event_calendar.evaluate_date_format_option(:date_format_integer, @date)
      end
    end
    
    context 'when calling method_missing it' do
      should 'read an option' do
        assert_equal @event_calendar.options[:date_format_string], @event_calendar.date_format_string
      end
      
      should 'write an option' do
        assert_equal @event_calendar.options[:date_format_string], @event_calendar.date_format_string
        @event_calendar.date_format_string = 'testing'
        assert_equal 'testing', @event_calendar.options[:date_format_string]
      end
      
      should 'call super if an option does not exist' do
        assert_raises NoMethodError do
          @event_calendar.missing_option
        end
      end
    end
    
    context 'when rendering it' do
      should 'render the default template' do
        assert_match /id="#{@event_calendar.id}"/, @event_calendar.to_s
      end
      
      should 'read and render a different template file' do
        @event_calendar.template = File.join(fixtures_path, 'template.mab')
        assert_equal '<div class="event_calendar"></div>', @event_calendar.to_s
      end
      
      should 'render a template string' do
        @event_calendar.template = "div.testing do\nend"
        assert_equal '<div class="testing"></div>', @event_calendar.to_s
      end
    end
    
    should 'return an array of weeks containing seven days when calling weeks' do
      @weeks = (Date.civil(2009, 9, 27)..Date.civil(2009, 10, 31)).to_a.in_groups_of(7).collect { |week| EventCalendar::Week.new(week, @event_calendar.events) }
      assert_equal @weeks, @event_calendar.weeks
    end
  end
  
end