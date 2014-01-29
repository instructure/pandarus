What is Pandarus?
=================

Pandarus is a Ruby gem that makes it easy to access to the full Canvas API. It is also a code generator that has the potential to generate Canvas API support for other proramming languages.

Pandarus uses the Swagger spec. It depends on the canvas-lms API documentation to be accurate. If the documentation is accurate, the generated code should work. Because Pandarus is still fairly new, there are cases where the documentation hasn't been corrected, or where the code generation is not complete. Please feel free to make corrections in either case by adding pull requests.

Installation
------------

```
gem install pandarus
```

Example Usage
-------------

```
require 'pandarus'

client = Pandarus::V1_api.new(
  prefix: "https://pandamonium.instructure.com/api",
  token: "[YOUR API TOKEN HERE]")

client.get_single_course_courses(17, '')

# => <Pandarus::Course :id=>17, :sis_course_id=>"PANDA-101", :name=>"Pandarus: Canvas API Access", :course_code=>"PANDA-101", :workflow_state=>"available", :account_id=>2, :root_account_id=>nil, :start_at=>"2014-01-27T18:16:00Z", :end_at=>nil, :enrollments=>[{"type"=>"teacher", "role"=>"TeacherEnrollment"}], :calendar=>{"ics"=>"https://pandamonium.instructure.com/feeds/calendars/course_RyNBDB2Rtt5rxd9koFq3QbAxx1AqCimyN6xWYEmW.ics"}, :default_view=>"wiki", :syllabus_body=>nil, :needs_grading_count=>nil, :term=>nil, :apply_assignment_group_weights=>false, :permissions=>nil, :is_public=>nil, :public_syllabus=>true, :public_description=>nil, :storage_quota_mb=>500, :hide_final_grades=>false, :license=>nil, :allow_student_assignment_edits=>nil, :allow_wiki_comments=>nil, :allow_student_forum_attachments=>nil, :open_enrollment=>nil, :self_enrollment=>nil, :restrict_enrollments_to_course_dates=>nil>
```


Documentation
-------------

See the Canvas API documentation that Pandarus is built from:

http://api.instructure.com/

Pandarus method names are very similar to the descriptions in the documentation. If you follow three rules, you will be able to access the full API:

1. All descriptions get lower-cased and spaces become underscores
2. If there is an 'a', 'an' or 'the' in the description, ignore it
3. If there are two ways to access an API call (such as via /courses and /sections) then add a _courses or _sections suffix

**Examples:**

- The API documentation describes a "Get a single account" API. This becomes "get_single_account"
- "Reserve a time slot" becomes "reserve_time_slot"
- "Get a single course" becomes EITHER "get_single_course_courses" OR "get_single_course_accounts" because there are two ways to access the API.

Code Generation
---------------

To generate Ruby code from the api-docs.json, accompanying json files, and
this project's ruby template files:

mvn clean package scala:run -Dlauncher=ruby-codegen

(requires Java 1.7, may work on 1.6 but OOM errors have cropped up)

Authors
-------

Duane Johnson -- duane@instructure.com
Eric Adams -- eadams@instructure.com

