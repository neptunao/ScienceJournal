class AddRejectReasonToArticle < ActiveRecord::Migration
  def up
    add_column :articles, :reject_reason, :string
  end

  def down
    remove_column :articles, :reject_reason
  end
end
