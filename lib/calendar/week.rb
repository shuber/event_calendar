class Calendar
  class Week < Array
    
    extend ActiveSupport::Memoizable
    
    def initialize(array, events, options)
      super(array)
      @events = events
      @options = options
    end
    
    def events
      # sort into rows
      @events
    end
    memoize :events
    
  end
end