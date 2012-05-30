class AddJournalIdToDataFile < ActiveRecord::Migration
  def up
    add_column :data_files, :journal_id, :integer
  end

  def down
    remove_column :data_files, :journal_id
  end
end
