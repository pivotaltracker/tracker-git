FactoryGirl.define do
  factory :commit do
    data "MyString"
sha "MyString"
parent_sha "MyString"
patch_id "MyString"
message "MyString"
author_github_user_id 1
author_date "2015-02-27 15:44:27"
committer_github_user_id 1
committer_date "2015-02-27 15:44:27"
push_id 1
  end

end