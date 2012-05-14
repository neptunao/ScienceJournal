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
    user.name     "Michael Hartl"
    user.email    "michael@example.com"
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
end