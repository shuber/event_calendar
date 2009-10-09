require 'fileutils'

namespace :calendar do
  namespace :generate do
    desc 'Generates css for the calendar'
    task :css => :sandbox do
      require 'haml'
      require 'sass/engine'
      file = File.join(File.dirname(__FILE__), 'lib', 'calendar', 'stylesheet.sass')
      css = Sass::Engine.new(File.read(file)).to_css
      File.open(File.join(Sandbox, 'calendar.css'), 'w+') { |file| file.write css }
      puts css
    end
    
    desc 'Creates a sandbox directory in your gem root'
    task :sandbox do
      Sandbox = File.join(File.dirname(__FILE__), '..', '..', 'sandbox')
      FileUtils.mkdir(Sandbox) unless File.exists?(Sandbox)
    end
  end
end