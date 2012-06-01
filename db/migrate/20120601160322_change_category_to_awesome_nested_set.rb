class ChangeCategoryToAwesomeNestedSet < ActiveRecord::Migration
  def up
    add_column :categories, :lft, :integer
    add_column :categories, :rgt, :integer
    add_column :categories, :depth, :integer
  end

  def down
    remove_column :categories, :lft
    remove_column :categories, :rgt
    remove_column :categories, :depth
  end
end
