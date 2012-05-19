class Censor < ActiveRecord::Base
  attr_accessible :degree, :first_name, :last_name, :middle_name, :post
  validates :first_name, :last_name, :degree, :post, presence: true
  has_one :user, as: :person
end
