class Calendar
  class Week < Array
    
    extend ActiveSupport::Memoizable
    
    def initialize(array, events, options)
      super(array)
      @events = events.sort_by(&:start)
      @options = options
    end
    
    def events
      week_events = inject([]) do |week, day|
        week << @events.select do |event| 
          (event.start_date == day || (event.start_date < day && day == first)) && event.end_date >= day
        end.map do |event| 
          [event, event.days(first, last), event.start_date < first || event.end_date > last]
        end
      end
      
      rows = []
      until week_events.all? { |day| day.empty? }
        row = []
        week_events.each_with_index do |day, index|
          cells = row.inject(0) { |sum, event| sum += (event.empty? ? 1 : event[1]) }
          next if cells > index || cells >= 7
          row << (day.empty? ? [] : day.shift)
        end
        rows << row
      end
      rows
    end
    memoize :events
      
  end
end