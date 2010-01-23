class EventCalendar
  
  # Provides conveniece methods for calculating dates and spans for an event. Stores the real event object for
  # proxying all other method calls to it.
  class Event
    
    undef_method :id
    
    attr_reader :event, :options
    
    # Accepts a real event object which it stores to proxy method calls to, and a hash of options obtained from the
    # <tt>EventCalendar</tt> instance.
    def initialize(event, options)
      @event, @options = event, options
    end
    
    # Calculates the number of days this day takes up on a calendar (rounding up).
    # Optionally accepts <tt>week_start</tt> and <tt>week_end</tt> dates to calculate how many days an event takes
    # up in a single week. For example, if an event started on a Friday and ended the following Wednesday, calling
    # <tt>@event.days(the_sunday_after_the_event_starts)</tt> would return 4.
    def days(week_start = start_date, week_end = end_date)
      (end_date > week_end ? week_end : end_date) - (start_date < week_start ? week_start : start_date) + 1
    end
    
    # Returns the end date of the event. If the event stores its end as a datetime then it is converted to a date.
    def end_date
      self.end.to_date
    end
    
    # Returns the start date of the event. If the event stores its start as a datetime then it is converted to a date.
    def start_date
      start.to_date
    end
    
    # Allows you to read options starting with <tt>:event_</tt> using method notation.
    #
    # For example: calling <tt>@event.title</tt> will return the value of <tt>@event.options[:event_title]</tt> if
    # that option exists.
    #
    # All other calls are delegated to the real <tt>:event</tt> object.
    def method_missing(method, *args)
      option = "event_#{method}".to_sym
      if @options.has_key?(option)
        evaluate_option(option)
      else
        @event.send(method, *args)
      end
    end
    
    protected
    
      # Looks up the specified option returns the evaluated the result.
      #
      # If the value of the option is a symbol, then it calls <tt>@event.send(value)</tt>
      #
      # If the value of the option is a proc, then it calls the proc and passes the current <tt>Event</tt>
      # instance as an argument.
      #
      # Any other value is simply returned.
      def evaluate_option(option)
        value = @options[option]
        case value
          when Symbol
            @event.send(value)
          when Proc
            value.call(self)
          else
            value
        end
      end
      
  end
end