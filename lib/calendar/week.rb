class Calendar
  class Week < Array
    
    extend ActiveSupport::Memoizable
    
    def initialize(array, events, options)
      super(array)
      @events = events.sort_by(&options[:event_start])
      @options = options
    end
    
    def events
      week_events = inject([]) do |week, day|
        week << @events.select do |event| 
          event_start, event_end = dates(event)
          (event_start == day || (event_start < day && day == first)) && event_end >= day
        end.map { |event| [event, days(event)] }
      end
      # [
      #   [[event, 1], [], [event, 1], [event, 4]],
      #   [[event, 2], [], [], [], [], [event, 1]]
      # ]
      []
    end
    memoize :events
    
    protected
    
      def dates(event)
        [event.send(@options[:event_start]).to_date, event.send(@options[:event_end]).to_date]
      end
      
      def days(event)
        event_start, event_end = dates(event)
        (event_end > last ? last : event_end) - (event_start < first ? first : event_start) + 1
      end
      
  end
end