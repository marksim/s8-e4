require 'test_helper'

module Admin
  class CoursesTest < ActionDispatch::IntegrationTest

    story "As an admin, I want to search courses" do
      setup do
        sign_user_in(Factory(:user, :access_level => 'admin'))
        {
          "Alpha" => ["Larry", "Moe", "Curly"], 
          "Beta" => ["John", "Paul", "George"], 
          "Gamma" => ["David", "Jason", "Jamis"], 
          "Delta" => ["Harry", "Ron", "Hermione"]
        }.each do |course_name, assignment_names|
          course = Factory.create(:course, :name => course_name, :description => "My project about #{name}")
          assignment_names.each do |assignment_name|
            assignment = Factory.create(:assignment, :course => course, :name => assignment_name)
          end
        end
      end

      scenario "view courses page without searching" do
        visit '/admin/courses'
        assert_current_path '/admin/courses'

        assert_content "Alpha"
      end

      scenario "view courses page searching for the course name" do
        visit '/admin/courses'

        fill_in 'search', :with => "Gamma"

        click_button "Search"

        assert_current_path '/admin/courses'

        assert_content "Gamma"
        assert_no_content "Alpha"
        assert_no_content "Beta"
        assert_no_content "Delta"
      end

      scenario "view courses page searching for the assignment name" do
        visit '/admin/courses'

        fill_in 'search', :with => "Paul"

        click_button "Search"

        assert_current_path '/admin/courses'

        assert_content "Beta"
        assert_no_content "Alpha"
        assert_no_content "Gamma"
        assert_no_content "Delta"
      end
    end
  end
end