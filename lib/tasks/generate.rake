require 'fileutils'

CALENDAR_ROOT = File.join(File.dirname(__FILE__), '..', '..')
ASSETS_ROOT = File.join(CALENDAR_ROOT, 'assets')
SANDBOX_ROOT = File.join(CALENDAR_ROOT, 'sandbox')

namespace :calendar do
  namespace :generate do
    desc 'Generates css for the calendar'
    task :css => :build_css do
      puts File.read(File.join(ASSETS_ROOT, 'stylesheets', 'calendar.css'))
    end
    
    desc 'Generates js for the calendar'
    task :js do
      puts File.read(File.join(ASSETS_ROOT, 'javascripts', 'calendar.js'))
    end
    
    desc 'Creates a sandbox in the gem root for testing'
    task :sandbox => [:build_css] do
      $:.unshift(File.join(CALENDAR_ROOT, 'lib'))
      require 'timecop'
      require 'active_support'
      require 'markaby'
      require 'calendar'
      
      FileUtils.mkdir(SANDBOX_ROOT) unless File.exists?(SANDBOX_ROOT)
      FileUtils.cp_r(File.join(ASSETS_ROOT, '.'), SANDBOX_ROOT)
      
      Event = Struct.new(:title, :starts_at, :ends_at) do
        def id; object_id; end
      end
      
      Timecop.freeze(Date.civil(2009, 10, 6)) do
        events = [
          Event.new('Event 1', Time.now, 10.minutes.from_now),
          Event.new('Event 1a', Time.now, 10.minutes.from_now),
          Event.new('Event 1b', Time.now, 10.minutes.from_now),
          Event.new('Event 1c', Time.now, 10.minutes.from_now),
          Event.new('Event 2', 1.day.from_now, 1.5.days.from_now),
          Event.new('Event 3', Time.now, 3.days.from_now),
          Event.new('Event 4 has a longer title', 3.days.from_now, 5.days.from_now),
          Event.new('Event 5 spans across multiple weeks', 4.days.from_now, 12.days.from_now)
        ]
        @calendar = Calendar.new(Time.now.year, Time.now.month, :events => events)
      end
      
      File.open(File.join(SANDBOX_ROOT, 'index.html'), 'w+') do |file|
        file.write <<-EOF
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
            <head>
                <title>Calendar</title>
                <meta http-equiv="Content-Type" content="application/xhtml+xml; charset=UTF-8" />
                <link href="stylesheets/yui-2.7.0.css" media="screen" rel="stylesheet" type="text/css" />
                <link href="stylesheets/calendar.css" media="screen" rel="stylesheet" type="text/css" />
                <script src="javascripts/prototype-1.6.1.js" type="text/javascript"></script>
                <script src="javascripts/calendar.js" type="text/javascript"></script>
                <script type="text/javascript">
                    //<![CDATA[
                    document.observe('dom:loaded', function() {
                      $$('.calendar').each(function(element) {
                        new Calendar(element);
                      });
                    });
                    //]]>
                </script>
            </head>
            <body>
              #{@calendar}
            </body>
        </html>
        EOF
      end
    end
    
    task :build_css do
      require 'haml'
      require 'sass/engine'
      
      sass = File.join(CALENDAR_ROOT, 'lib', 'calendar', 'stylesheet.sass')
      File.open(File.join(ASSETS_ROOT, 'stylesheets', 'calendar.css'), 'w+') do |file| 
        file.write Sass::Engine.new(File.read(sass)).to_css
      end
    end
  end
end