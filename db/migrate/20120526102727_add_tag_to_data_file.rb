class AddTagToDataFile < ActiveRecord::Migration
  def up
    add_column :data_files, :tag, :string
  end

  def down
    remove_column :data_files, :tag
  end
end
