require 'calendar/event'
require 'calendar/week'

Date.class_eval { attr_accessor :events }

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
    self.year, self.month, self.options = year, month, self.class.default_options.merge(options)
    self.events = events.collect { |event| Event.new(event, self.options) }.sort_by(&:start)
    yield self if block_given?
  end
  
  def date
    Date.civil(year, month, 1)
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
    days_in_month = Time.days_in_month(month, year)
    starting_day = date.beginning_of_week() -1.day + beginning_of_week.days
    ending_day = (date + days_in_month).end_of_week() -1.day + beginning_of_week.days
    (starting_day..ending_day).to_a.in_groups_of(7).collect { |week| Week.new(week, events) }
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