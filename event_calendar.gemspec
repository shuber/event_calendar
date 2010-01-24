Gem::Specification.new do |s|
  s.name = %q{event_calendar}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sean Huber"]
  s.date = %q{2010-01-23}
  s.description = %q{Generates HTML event calendars}
  s.email = %q{shuber@huberry.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
    "MIT-LICENSE",
    "README.rdoc",
    "Rakefile",
    "assets/javascripts/event_calendar.prototype.js",
    "assets/stylesheets/event_calendar.css",
    "init.rb",
    "lib/event_calendar.rb",
    "lib/event_calendar/event.rb",
    "lib/event_calendar/stylesheet.sass",
    "lib/event_calendar/template.mab",
    "lib/event_calendar/week.rb",
    "lib/tasks/generate.rake",
    "test/date_test.rb",
    "test/event_calendar_test.rb",
    "test/event_test.rb",
    "test/fixtures/template.mab",
    "test/test_helper.rb",
    "test/week_test.rb"
  ]
  s.homepage = %q{http://github.com/shuber/event_calendar}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Generates HTML event calendars}
  s.test_files = [
    "test/date_test.rb",
    "test/event_calendar_test.rb",
    "test/event_test.rb",
    "test/fixtures/template.mab",
    "test/test_helper.rb",
    "test/week_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<active_support>, [">= 0"])
      s.add_runtime_dependency(%q<markaby>, [">= 0"])
      s.add_runtime_dependency(%q<haml>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<timecop>, [">= 0"])
    else
      s.add_dependency(%q<active_support>, [">= 0"])
      s.add_dependency(%q<markaby>, [">= 0"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<timecop>, [">= 0"])
    end
  else
    s.add_dependency(%q<active_support>, [">= 0"])
    s.add_dependency(%q<markaby>, [">= 0"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<timecop>, [">= 0"])
  end
end
