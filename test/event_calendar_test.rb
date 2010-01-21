require 'test_helper'

Event = Struct.new(:title, :starts_at, :ends_at) do
  def id; object_id; end
end

class EventCalendarTest < Test::Unit::TestCase

  should 'test this gem' do
    flunk
  end
  
end