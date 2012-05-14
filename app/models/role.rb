class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  attr_accessible :name
  validates :name, presence: true, uniqueness: true

  def self.guest_role
    find_by_name(:guest)
  end
  def self.admin_role
    find_by_name(:admin)
  end
  def self.author_role
    find_by_name(:author)
  end
  def self.censor_role
    find_by_name(:censor)
  end
end
