class AddCategoryIdToArticle < ActiveRecord::Migration
  def up
    add_column :articles, :category_id, :integer
  end

  def down
    remove_column :articles, :category_id
  end
end
