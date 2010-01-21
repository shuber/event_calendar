class EventCalendar
  class Week < Array
    
    extend ActiveSupport::Memoizable
    
    def initialize(days, events)
      super days
      add_associated_events_to_days(events)
    end
    
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
    
      def add_associated_events_to_days(events)
        each { |day| day.events = events.select { |event| event.start_date == day || (event.start_date < day && event.end_date >= day && day == first) } }
      end
    
  end
end