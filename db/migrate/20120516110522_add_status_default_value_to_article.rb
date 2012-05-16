class AddStatusDefaultValueToArticle < ActiveRecord::Migration
  def change
    change_column :articles, :status, :integer, default: 0
  end
end
