require 'test_helper'

class DateTest < Test::Unit::TestCase

  context 'a date' do
    setup { @date = Time.now.to_date }
    
    should 'have an events attr_accessor' do
      assert @date.respond_to?(:events)
      assert @date.respond_to?(:events=)
    end
  end
  
end