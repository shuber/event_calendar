class Calendar
  
  undef_method :id
  
  attr_accessor :events, :month, :options, :year
  
  def self.default_options
    @default_options ||= {
      :id => 'calendar',
      :beginning_of_week => 0,
      :event_title => :title,
      :event_start => :starts_at,
      :event_end => :ends_at
    }
  end
  
  def initialize(year = Time.now.year, month = Time.now.month, events = [], options = {})
    self.year, self.month, self.events, self.options = year, month, events, self.class.default_options.merge(options)
    yield self if block_given?
  end
  
  def generate
    validate_options!
    
    date = Date.civil(self.year, self.month, 1)
    weeks = generate_weeks_for(date)
    render date, weeks
  end
  
  def method_missing(method, *args)
    method.to_s =~ /^([^=]+)(=?)$/
    options[$1.to_sym] = args.first unless $2.empty?
    options[$1.to_sym]
  end
  
  protected
  
    def generate_weeks_for(date)
      days_in_month = Time.days_in_month(self.month, self.year)
      starting_day = date.beginning_of_week() -1.day + beginning_of_week.days
      ending_day = (date + days_in_month).end_of_week() -1.day + beginning_of_week.days
      (starting_day..ending_day).to_a.in_groups_of(7)
    end
    
    def render(date, weeks)
      calendar = self
      Markaby::Builder.new do
        div.calendar.send("#{calendar.id}!") do
          div.header do
            table do
              tr.navigation do
                td.previous_month date.last_month.strftime('%B'), :colspan => 2
                td.current_month date.strftime('%B %Y'), :colspan => 3
                td.next_month date.next_month.strftime('%B'), :colspan => 2
              end
              tr.labels do
                weeks.first.each do |day|
                  td.day.label day.strftime('%a')
                end
              end
            end
          end
          div.body do
            weeks.each do |week|
              div.week do
                table do
                  tr.labels do
                    week.each do |day|
                      td.day.label day.strftime('%d').gsub(/^0/, '') # add current class and today
                    end
                  end
                end
                div.days do
                  table.grid do
                    tr do
                      week.each do |day| 
                        td.day.send("day_#{day}!") {}
                      end
                    end
                  end
                  unless calendar.events.empty?
                    table.events do
                    end
                  end
                end
              end
            end
          end
        end
      end.to_s
    end
    
    def validate_options!
      raise ArgumentError.new('beginning_of_week must be an integer between 0 and 6') unless beginning_of_week.is_a?(Integer) && (0..6).include?(beginning_of_week)
    end
    
end