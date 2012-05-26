class AddCensorIdToArticle < ActiveRecord::Migration
  def up
    add_column :articles, :censor_id, :integer
  end

  def down
    remove_column :articles, :censor_id
  end
end
