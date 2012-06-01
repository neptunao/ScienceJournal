class Category < ActiveRecord::Base
  include TheSortableTree::Scopes

  has_many :children, class_name: 'Category', :foreign_key => 'parent_id'
  belongs_to :parent_category, class_name: 'Category', :foreign_key => "parent_id"
  attr_accessible :title
  validates :title, presence: true
  acts_as_nested_set
end
