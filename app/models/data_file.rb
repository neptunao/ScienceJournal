class DataFile < ActiveRecord::Base
  attr_accessible :filename
  validates :filename, presence: true, uniqueness: true
end
