class EventCalendar
  
  # Contains an array of days representing a calendar week
  class Week < Array
    
    extend ActiveSupport::Memoizable
    
    # Accepts two arguments, an array of days and an array of events
    def initialize(days, events)
      super days
      add_associated_events_to_days(events)
    end
    
    # Returns an array of arrays containing hashes of events to fit in an HTML calendar week row.
    #
    # Each hash in the array represents a table cell <tt>td</tt> when the calendar is generated.
    # If the hash is empty, an empty <tt>td</tt> would be generated. Otherwise, the <tt>td</tt>
    # will contain information related to the associated event. An event hash contains:
    #
    #   :event      =>  The event object.
    #   :span       =>  The number of days this event takes up in the current week row.
    #   :continued  =>  A boolean determining if this event starts before or ends after the current week.
    #
    # For example:
    #
    #   puts @week.events.inspect
    #
    #   # [
    #   #   [{}, {}, { :event => ..., :span => 1, :continued => false }, { :event => ..., :span => 1, :continued => false}, {}, {}, {}],
    #   #   [{}, {}, { :event => ..., :span => 1, :continued => false }, {}, {}, {}, { :event => ..., :span => 1, :continued => true }],
    #   #   [{}, {}, { :event => ..., :span => 1, :continued => false }, {}, {}, {}, {}],
    #   #   [{}, {}, { :event => ..., :span => 1, :continued => false }, {}, {}, {}, {}],
    #   #   [{}, {}, { :event => ..., :span => 4, :continued => false }, {}]
    #   # ]
    def events
      events = []
      day_events_index = inject({}) { |hash, day| hash.merge! day => 0 }
      until all? { |day| day_events_index[day] == day.events.size }
        row = []
        each_with_index do |day, index|
          cell_count = row.inject(0) { |sum, cell| sum += (cell.empty? ? 1 : cell[:span]) }
          next if cell_count > index || cell_count >= 7
          
          cell = {}
          unless day_events_index[day] == day.events.size
            cell[:event] = day.events[day_events_index[day]]
            cell[:span] = cell[:event].days(first, last)
            cell[:continued] = cell[:event].days != cell[:span]
            day_events_index[day] += 1
          end
          row << cell
        end
        events << row
      end
      events
    end
    memoize :events
    
    protected
    
      # Loops through each day in this week and adds any associated events to its <tt>:events</tt> array.
      def add_associated_events_to_days(events)
        each { |day| day.events = events.select { |event| event.start_date == day || (event.start_date < day && event.end_date >= day && day == first) } }
      end
    
  end
end