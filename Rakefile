require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
 
desc 'Default: run the sortable tests'
task :default => :test
 
desc 'Test the calendar gem/plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/*_test.rb'
  t.verbose = true
end
 
desc 'Generate documentation for the calendar gem/plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'calendar'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :calendar do
  namespace :generate do
    desc 'Generates css for the calendar'
    task :css do
      require 'haml'
      require 'sass/engine'
      file = File.join(File.dirname(__FILE__), 'lib/calendar.sass')
      puts Sass::Engine.new(File.read(file)).to_css
    end
  end
end