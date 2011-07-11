require 'test_helper'

class CoursesHelperTest < ActionView::TestCase
  include CoursesHelper

  context '#course_dates' do
    context 'for a course with a start and end date' do
      setup do
        @course = Factory(:course,
                          :start_date => Date.parse('2010-09-17'),
                          :end_date => Date.parse('2010-11-01'))
      end

      should 'show the duration of the course' do
        assert_equal '17 September 2010 thru 01 November 2010',
                     course_dates(@course)
      end
    end

    context 'for a course lacking an end date' do
      setup do
        @course = Factory(:course, :start_date => nil)
      end

      should 'be an empty string' do
        assert_equal '', course_dates(@course)
      end
    end
  end
end
