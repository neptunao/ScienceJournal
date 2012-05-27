class Censor < ActiveRecord::Base
  attr_accessible :degree, :first_name, :last_name, :middle_name, :post
  validates :first_name, :last_name, :degree, :post, presence: true
  has_one :user, as: :person

  def fullname
    "#{last_name} #{first_name} #{middle_name}"
  end
end
