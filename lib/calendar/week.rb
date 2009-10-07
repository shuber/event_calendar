class Calendar
  class Week < Array
    
    extend ActiveSupport::Memoizable
    
    def initialize(array, events, options)
      super(array)
      @events = events.sort_by(&options[:event_start])
      @options = options
    end
    
    def events
      # week_events = Array.new(7)
      # @events.each do |event|
      #   weekday_index = event.send(@options[:event_start]).to_date.SOMETHING
      #   week_events[weekday_index] << event
      # end
      
      # [[], [], [], [], [], [], []]
      
      # [
      #   [[event, 1], [], [event, 1], [event, 4]],
      #   [[event, 2], [], [], [], [], [event, 1]]
      # ]
      []
    end
    memoize :events
    
    protected
    
      def days(event)
        event_start = event.send(@options[:event_start]).to_date
        event_end = event.send(@options[:event_end]).to_date
        (event_end > last ? last : event_end) - (event_start < first ? first : event_start) + 1
      end
      
  end
end