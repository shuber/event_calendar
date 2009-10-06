class Calendar
  
  undef_method :id
  
  attr_accessor :events, :month, :options, :year
  
  def self.default_options
    @default_options ||= {
      :id                 => 'calendar',
      :beginning_of_week  => 0,
      :event_id           => :id,
      :event_title        => :title,
      :event_start        => :starts_at,
      :event_end          => :ends_at
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
  alias_method :to_html, :generate
  
  def method_missing(method, *args)
    if method.to_s =~ /^([^=]+)(=?)$/ && options.has_key?($1.to_sym)
      options[$1.to_sym] = args.first unless $2.empty?
      options[$1.to_sym]
    else
      super
    end
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
        div.calendar.send(date.strftime('%B').downcase).send("#{calendar.id}!") do
          div.header do
            table do
              tbody do
                tr.navigation do
                  td.previous_month date.last_month.strftime('%B'), :colspan => 2
                  td.current_month date.strftime('%B %Y'), :colspan => 3
                  td.next_month date.next_month.strftime('%B'), :colspan => 2
                end
                tr.labels do
                  weeks.first.each do |day|
                    day_label = td.day
                    day_label = day_label.send(day.strftime('%A').downcase)
                    day_label = day_label.today if day.cwday == Time.now.to_date.cwday
                    day_label.label day.strftime('%a')
                  end
                end
              end
            end
          end
          div.body do
            weeks.each do |week|
              div.week.send("#{calendar.id}_week_#{week.first}_#{week.last}!") do
                table.send("#{calendar.id}_labels_#{week.first}_#{week.last}!") do
                  tbody do
                    tr.labels do
                      week.each do |day|
                        day_label = td.day
                        day_label = day_label.send(day.month == date.month ? 'current_month' : day < date ? 'previous_month' : 'next_month')
                        day_label = day_label.send([6, 7].include?(day.cwday) ? 'weekend' : 'weekday')
                        day_label = day_label.send(day.strftime('%A').downcase)
                        day_label = day_label.send(day.strftime('%B').downcase)
                        day_label = day_label.send("day_#{day.strftime('%d').gsub(/^0/, '')}")
                        day_label = day_label.today if day == Time.now.to_date
                        day_label.label day.strftime('%d').gsub(/^0/, '')
                      end
                    end
                  end
                end
                div.days.send("#{calendar.id}_days_#{week.first}_#{week.last}!") do
                  table.grid.send("#{calendar.id}_grid_#{week.first}_#{week.last}!") do
                    tbody do
                      tr do
                        week.each do |day| 
                          day_grid = td.day
                          day_grid = day_grid.send(day.month == date.month ? 'current_month' : day < date ? 'previous_month' : 'next_month')
                          day_grid = day_grid.send([6, 7].include?(day.cwday) ? 'weekend' : 'weekday')
                          day_grid = day_grid.send(day.strftime('%A').downcase)
                          day_grid = day_grid.send(day.strftime('%B').downcase)
                          day_grid = day_grid.send("day_#{day.strftime('%d').gsub(/^0/, '')}")
                          day_grid = day_grid.today if day == Time.now.to_date
                          day_grid.send("#{calendar.id}_day_#{day}!") {}
                        end
                      end
                    end
                  end
                  unless calendar.events.empty?
                    table.events.send("#{calendar.id}_events_#{week.first}_#{week.last}!") do
                      tbody do
                        # TODO
                      end
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