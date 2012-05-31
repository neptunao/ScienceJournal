class AddJournalIdToArticle < ActiveRecord::Migration
  def up
    add_column :articles, :journal_id, :integer
  end

  def down
    remove_column :articles, :journal_id
  end
end
