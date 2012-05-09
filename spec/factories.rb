FactoryGirl.define do
  factory :author_role, class: 'Role' do
    name :author
  end
  factory :guest_role, class: 'Role' do
    name :guest
  end
  factory :user do |user|
    user.name     "Michael Hartl"
    user.email    "michael@example.com"
    user.password "foobar"
    user.password_confirmation "foobar"
    user.user_roles { |role| [role.association(:author_role), role.association(:guest_role)] }
  end
  factory :guest_user, class: 'User' do |user|
    user.name     "Guest"
    user.email    "guest@example.com"
    user.password "foobar"
    user.password_confirmation "foobar"
    user.user_roles { |role| [role.association(:guest_role)] }
  end
end