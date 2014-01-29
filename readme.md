== Installation

```
gem install pandarus
```

== Example Usage

```
require 'pandarus'

client = Pandarus::V1_api.new(
  prefix: "https://pandamonium.instructure.com/api",
  token: "[YOUR API TOKEN HERE]")

client.get_single_course_courses(17, '')

# <Pandarus::Course :id=>17, :sis_course_id=>"PANDA-101", :name=>"Pandarus: Canvas API Access", :course_code=>"PANDA-101", :workflow_state=>"available", :account_id=>2, :root_account_id=>nil, :start_at=>"2014-01-27T18:16:00Z", :end_at=>nil, :enrollments=>[{"type"=>"teacher", "role"=>"TeacherEnrollment"}], :calendar=>{"ics"=>"https://pandamonium.instructure.com/feeds/calendars/course_RyNBDB2Rtt5rxd9koFq3QbAxx1AqCimyN6xWYEmW.ics"}, :default_view=>"wiki", :syllabus_body=>nil, :needs_grading_count=>nil, :term=>nil, :apply_assignment_group_weights=>false, :permissions=>nil, :is_public=>nil, :public_syllabus=>true, :public_description=>nil, :storage_quota_mb=>500, :hide_final_grades=>false, :license=>nil, :allow_student_assignment_edits=>nil, :allow_wiki_comments=>nil, :allow_student_forum_attachments=>nil, :open_enrollment=>nil, :self_enrollment=>nil, :restrict_enrollments_to_course_dates=>nil>
```

== Documentation

See the Canvas API documentation that Pandarus is built from:

http://api.instructure.com/

== Code Generation

To generate Ruby code from the api-docs.json, accompanying json files, and
this project's ruby template files:

mvn clean package scala:run -Dlauncher=ruby-codegen

(requires Java 1.7, may work on 1.6 but OOM errors have cropped up)