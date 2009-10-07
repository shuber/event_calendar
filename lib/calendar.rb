require 'calendar/week'

class Calendar
  
  extend ActiveSupport::Memoizable
  
  undef_method :id
  
  attr_accessor :events, :month, :options, :year
  
  def self.default_options
    @default_options ||= {
      :id                 => 'calendar',
      :beginning_of_week  => 0,
      :event_class        => nil,
      :event_id           => :id,
      :event_title        => :title,
      :event_start        => :starts_at,
      :event_end          => :ends_at,
      :template           => File.join(File.dirname(__FILE__), 'calendar', 'template.mab')
    }
  end
  
  def initialize(year = Time.now.year, month = Time.now.month, events = [], options = {})
    self.year, self.month, self.events, self.options = year, month, events, self.class.default_options.merge(options)
    yield self if block_given?
  end
  
  def date
    Date.civil(self.year, self.month, 1)
  end
  memoize :date
  
  def method_missing(method, *args)
    if method.to_s =~ /^([^=]+)(=?)$/ && options.has_key?($1.to_sym)
      options[$1.to_sym] = args.first unless $2.empty?
      options[$1.to_sym]
    else
      super
    end
  end
  
  def to_html
    date(:reload)
    weeks(:reload)
    render
  end
  
  def weeks
    days_in_month = Time.days_in_month(self.month, self.year)
    starting_day = date.beginning_of_week() -1.day + beginning_of_week.days
    ending_day = (date + days_in_month).end_of_week() -1.day + beginning_of_week.days
    (starting_day..ending_day).to_a.in_groups_of(7).map do |week| 
      events_during_this_week = self.events.select do |event| 
        event.send(options[:event_start]).to_date <= week.last && event.send(options[:event_end]).to_date >= week.first
      end
      Week.new(week, events_during_this_week, options)
    end
  end
  memoize :weeks
  
  protected
    
    def render
      render_with_markaby
    end
    
    def render_with_markaby
      Markaby::Builder.new(:calendar => self, :template => File.read(template)) { eval(template) }.to_s
    end
    
end