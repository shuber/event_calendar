require 'test/unit'
require 'rubygems'
require 'active_support'
require 'markaby'
require File.dirname(__FILE__) + '/../lib/calendar'

class CalendarTest < Test::Unit::TestCase
  
  def test_this_lib
    c = Calendar.new
    puts c.generate
  end
  
end