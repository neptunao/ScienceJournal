FactoryGirl.define do
  factory :role do
    name 'Autor'
  end
  factory :user do
    name     "Michael Hartl"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
    user_roles { [FactoryGirl.create(:role)] }
  end
end