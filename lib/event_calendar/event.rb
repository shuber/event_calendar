class EventCalendar
  class Event
    
    undef_method :id
    
    def initialize(event, options)
      @event, @options = event, options
    end
    
    def days(week_start = start_date, week_end = end_date)
      (end_date > week_end ? week_end : end_date) - (start_date < week_start ? week_start : start_date) + 1
    end
    
    def end_date
      self.end.to_date
    end
    
    def start_date
      start.to_date
    end
    
    def method_missing(method, *args)
      option = "event_#{method}".to_sym
      if @options.has_key?(option)
        evaluate_option(option)
      else
        @event.send(method, *args)
      end
    end
    
    protected
    
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