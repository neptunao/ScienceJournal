FactoryGirl.define do
  factory :author_role, class: 'Role' do
    name :author
  end
  factory :guest_role, class: 'Role' do
    name :guest
  end
  factory :censor_role, class: 'Role' do
    name :censor
  end
  factory :admin_role, class: 'Role' do
    name :admin
  end
  factory :user do |user|
    user.sequence(:name) { |n| "author_user_#{n}" }
    user.sequence(:email) { |n| "michael#{n}@example.com"  }
    user.password "foobar"
    user.password_confirmation "foobar"
    user.roles { |role| [Role.author_role || role.association(:author_role), Role.guest_role || role.association(:guest_role)] }
    user.after(:create) { |u| u.send :post_init }
  end
  factory :guest_user, class: 'User' do |user|
    user.name     "Guest"
    user.email    "guest@example.com"
    user.password "foobar"
    user.password_confirmation "foobar"
    user.roles { |role| [Role.guest_role || role.association(:guest_role)] }
    user.after(:create) { |u| u.send :post_init }
  end
  factory :censor_user, class: 'User' do |user|
    user.name     "Censor"
    user.email    "censor@example.com"
    user.password "foobar"
    user.password_confirmation "foobar"
    user.roles { |role| [Role.censor_role ||role.association(:censor_role)] }
    user.after(:create) { |u| u.send :post_init }
  end
  factory :admin_user, class: 'User' do |user|
    user.name     "test_admin"
    user.email    "testadmin@example.com"
    user.password "foobar"
    user.password_confirmation "foobar"
    user.roles { |role| [Role.admin_role ||role.association(:admin_role)] }
    user.after(:create) { |u| u.send :post_init }
  end
  factory :data_file, class: 'DataFile' do |file|
    file.sequence(:filename)
  end
  factory :author do |author|
    author.sequence(:first_name) { |n| "first_name_#{n}"}
    author.middle_name 'middle_name'
    author.sequence(:last_name) { |n| "last_name_#{n}"}
  end
  factory :censor do |censor|
    censor.sequence(:first_name) { |n| "first_name_#{n}"}
    censor.middle_name 'middle_name'
    censor.sequence(:last_name) { |n| "last_name_#{n}"}
    censor.sequence(:degree) { |n| "degree#{n}" }
    censor.sequence(:post) { |n| "post#{n}" }
  end
end