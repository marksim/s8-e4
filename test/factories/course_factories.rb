Factory.sequence(:course_name) { |n| "Course #{n}" }

Factory.define :course do |u|
  u.name { |_| Factory.next(:course_name) }
  u.association :term
end

Factory.define :course_membership do |u|
  u.association  :course
  u.association  :user
  u.access_level "student"
end
