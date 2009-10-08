class Calendar
  class Week < Array
    
    extend ActiveSupport::Memoizable
    
    def initialize(days, events)
      super days
      each { |day| day.events = events.select { |event| event.start_date == day || (event.start_date < day && event.end_date >= day && day == days.first) } }
    end
    
    def events
      events = []
      until all? { |day| day.events.empty? }
        row = []
        each_with_index do |day, index|
          cell_count = row.inject(0) { |sum, cell| sum += (cell.empty? ? 1 : cell[:span]) }
          next if cell_count > index || cell_count >= 7
          
          cell = {}
          unless day.events.empty?
            cell[:event] = day.events.shift
            cell[:span] = cell[:event].days(first, last)
            cell[:continued] = cell[:event].days != cell[:span]
          end
          row << cell
        end
        events << row
      end
      events
    end
    memoize :events
      
  end
end