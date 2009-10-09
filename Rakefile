require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'shuber-calendar'
    gem.summary = 'Generates HTML event calendars'
    gem.description = 'Generates HTML event calendars'
    gem.email = 'shuber@huberry.com'
    gem.homepage = 'http://github.com/shuber/calendar'
    gem.authors = ['Sean Huber']
    gem.add_dependency 'activesupport'
    gem.add_dependency 'markaby'
    gem.add_dependency 'haml'
    gem.add_development_dependency 'thoughtbot-shoulda'
    gem.add_development_dependency 'timecop'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler'
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort 'RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov'
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "calendar #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

namespace :calendar do
  namespace :generate do
    desc 'Generates css for the calendar'
    task :css do
      require 'haml'
      require 'sass/engine'
      file = File.join(File.dirname(__FILE__), 'lib', 'calendar', 'stylesheet.sass')
      css = Sass::Engine.new(File.read(file)).to_css
      sandbox = File.join(File.dirname(__FILE__), 'sandbox')
      File.open(File.join(sandbox, 'calendar.css'), 'w+') { |file| file.write css } if File.exists?(sandbox)
      puts css
    end
  end
end