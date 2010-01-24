require 'active_support'
require 'markaby'
require 'haml'
require 'event_calendar/event'
require 'event_calendar/week'

# Adds an <tt>:events</tt> <tt>attr_accessor</tt> to the <tt>Date</tt> object.
Date.class_eval { attr_accessor :events }

# Generates HTML calendars
class EventCalendar

  extend ActiveSupport::Memoizable
  
  undef_method :id
  
  attr_accessor :events, :options
  attr_reader :month, :year
  
  # The default options used when generating event calendars
  #
  #   :id                  =>  The HTML id of the generated container div for this event calendar. Defaults to 'event_calendar'.
  #   :beginning_of_week   =>  The day number to use as the beginning of the week. For example, 0 is for Sunday, 1 is for Monday, etc.
  #                            Defaults to 0.
  #   :day_label *         =>  The label to use for each day. Defaults to the day number.
  #   :event_class **      =>  The HTML class to add to each event. Defaults to nil.
  #   :event_id **         =>  The id (object_id or database id) of an event. Defaults to :id.
  #   :event_title **      =>  The title of an event. Defaults to :title.
  #   :event_start **      =>  The start date or datetime of an event. Defaults to :starts_at.
  #   :event_end **        =>  The end date or datetime of an event. Defaults to :ends_at.
  #   :event_url **        =>  The url of an event to use as the HTML href attribute. Defaults to '#'.
  #   :event_output **     =>  The HTML to output for an event. Defaults to a link to the :event_url using the :event_title
  #                            as its label and title attributes.
  #   :event_fields **     =>  The event fields to output as hidden attributes into the calendar so that they can be accessed with
  #                            javascript. Defaults to [:id, :title, :start, :end].
  #   :events              =>  An array of events to display in the calendar. Defaults to [].
  #   :header_label *      =>  The label to use as the header of the calendar. Defaults to the month name and year like 'October 2009'.
  #   :header_day_label *  =>  The label to use as the header of each day. Defaults to the abbreviated day name like 'Thu'.
  #   :navigation_label *  =>  The label to use as the inner HTML for the navigation links. Defaults to the full month name like 'November'.
  #   :navigation_url      =>  A proc which returns the url to use as the HTML href attribute for the previous and next month links. 
  #                            This proc is passed a date object representing the first day of the previous or next months. Defaults to '#'.
  #   :template            =>  A path to the Markaby template file to use when rendering the calendar. Defaults to the 'event_calendar/template.mab'
  #                            file found in this directory.
  #
  # *  See the EventCalendar.evaluate_date_format_option method for possible values.
  # ** See the Event#evaluate_option method for possible values.
  def self.default_options
    @default_options ||= {
      :id                 => 'event_calendar',
      :beginning_of_week  => 0,
      :day_label          => proc { |date| date.strftime('%d').gsub(/^0/, '') },
      :event_class        => nil,
      :event_id           => :id,
      :event_title        => :title,
      :event_start        => :starts_at,
      :event_end          => :ends_at,
      :event_url          => '#',
      :event_output       => proc { |event| "<a href=\"#{event.url}\" title=\"#{event.title}\">#{event.title}</a>" },
      :event_fields       => [:id, :title, :start, :end],
      :events             => [],
      :header_label       => '%B %Y',
      :header_day_label   => '%a',
      :navigation_label   => '%B',
      :navigation_url     => proc { |date| '#' },
      :template           => File.join(File.dirname(__FILE__), 'event_calendar', 'template.mab')
    }
  end
  
  # Optionally accepts a <tt>year</tt> as the first argument, a <tt>month</tt> (integer) as the second argument, and a
  # hash of options as the third argument. It also accepts a block which it passes itself to.
  #
  # For example:
  #
  #   @event_calendar = EventCalendar.new
  #
  #   @event_calendar = EventCalendar.new(2009, 10, :id => 'calendar', :events => Event.all)
  #   
  #   @event_calendar = EventCalendar.new(2009, 10) do |c|
  #     c.id = 'calendar'
  #     c.events = Event.all
  #   end
  def initialize(year = Time.now.year, month = Time.now.month, options = {})
    @year, @month, self.options = year, month, self.class.default_options.merge(options)
    @events = self.options.delete(:events).collect { |event| Event.new(event, self.options) }.sort_by(&:start)
    yield self if block_given?
  end
  
  # Returns a date object representing the first day of this <tt>EventCalendar</tt> instance's specified <tt>year</tt> and <tt>month</tt>.
  def date
    Date.civil(year, month, 1)
  end
  memoize :date
  
  # Looks up the specified option representing a date format and returns the evaluated the result.
  #
  # This is used inside the <tt>Markaby</tt> template. For example, we have an option <tt>:header_label</tt> which
  # represents the content at the top of the calendar that outputs the month name and year by default, like 
  # "October 2009".
  #
  # Inside the template, we call <tt>event_calendar.evaluate_date_format_option(:header_label, event_calendar.date)</tt>.
  #
  # If <tt>options[:header_label]</tt> is a string, it takes <tt>event_calendar.date</tt> and calls <tt>strftime(options[:header_label])</tt>
  # on it.
  #
  # If it's a symbol, it takes <tt>event_calendar.date</tt> and calls <tt>send(options[:header_label])</tt> on it.
  #
  # If it's a proc, it calls the proc and passes <tt>event_calendar.date</tt> to it. You can pass any number of args to this method
  # and they'll passed to the proc.
  #
  # Any other value for <tt>options[:header_label]</tt> is simply returned.
  def evaluate_date_format_option(option, *args)
    value = self.send(option)
    case value
      when String
        args.first.strftime(value)
      when Symbol
        args.first.send(value)
      when Proc
        value.call(*args)
      else
        value
    end
  end
  
  # Allows you to read and write options using method notation.
  #
  # For example:
  #
  #   @event_calendar = EventCalendar.new(2009, 10)
  #   @event_calendar.template = '/path/to/some/other/template.mab'
  #   puts @event_calendar.beginning_of_week
  def method_missing(method, *args)
    if method.to_s =~ /^([^=]+)(=?)$/ && options.has_key?($1.to_sym)
      options[$1.to_sym] = args.first unless $2.empty?
      options[$1.to_sym]
    else
      super
    end
  end
  
  # Returns the HTML representation of this <tt>EventCalendar</tt>.
  #
  # aliased as <tt>to_html</tt>
  def to_s
    render
  end
  alias_method :to_html, :to_s
  
  # Returns an array of week objects which contain date objects for every day that this calendar displays.
  # It may contain a few days from the previous and next months.
  #
  # The <tt>EventCalendar::Week</tt> class inherits from <tt>Array</tt>.
  #
  # For example:
  #
  #   puts EventCalendar.new(2009, 10).weeks.inspect
  #
  #   # [
  #   #   [Sun, 27 Sep 2009, Mon, 28 Sep 2009, Tue, 29 Sep 2009, Wed, 30 Sep 2009, Thu, 01 Oct 2009, Fri, 02 Oct 2009, Sat, 03 Oct 2009],
  #   #   [Sun, 04 Oct 2009, Mon, 05 Oct 2009, Tue, 06 Oct 2009, Wed, 07 Oct 2009, Thu, 08 Oct 2009, Fri, 09 Oct 2009, Sat, 10 Oct 2009],
  #   #   [Sun, 11 Oct 2009, Mon, 12 Oct 2009, Tue, 13 Oct 2009, Wed, 14 Oct 2009, Thu, 15 Oct 2009, Fri, 16 Oct 2009, Sat, 17 Oct 2009],
  #   #   [Sun, 18 Oct 2009, Mon, 19 Oct 2009, Tue, 20 Oct 2009, Wed, 21 Oct 2009, Thu, 22 Oct 2009, Fri, 23 Oct 2009, Sat, 24 Oct 2009],
  #   #   [Sun, 25 Oct 2009, Mon, 26 Oct 2009, Tue, 27 Oct 2009, Wed, 28 Oct 2009, Thu, 29 Oct 2009, Fri, 30 Oct 2009, Sat, 31 Oct 2009]
  #   # ]
  def weeks
    days_in_month = Time.days_in_month(month, year)
    starting_day = date.beginning_of_week() -1.day + beginning_of_week.days
    ending_day = (date + days_in_month).end_of_week() -1.day + beginning_of_week.days
    (starting_day..ending_day).to_a.in_groups_of(7).collect { |week| Week.new(week, events) }
  end
  memoize :weeks
  
  protected
    
    # Generates the HTML representation of this <tt>EventCalendar</tt>. The default implementation calls
    # <tt>render_with_markaby</tt>.
    def render
      render_with_markaby
    end
    memoize :render
    
    # Reads the template file specified in <tt>options[:template]</tt> and evaluates it with <tt>Markaby</tt>,
    # passing this <tt>EventCalendar</tt> instance as the <tt>event_calendar</tt> local variable.
    def render_with_markaby
      Markaby::Builder.new(:event_calendar => self, :template => File.exists?(template) ? File.read(template) : template) { eval(template) }.to_s
    end
    
end