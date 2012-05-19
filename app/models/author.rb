class Author < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :middle_name
  validates :first_name, :last_name, presence: true
  has_one :user, as: :person
end
