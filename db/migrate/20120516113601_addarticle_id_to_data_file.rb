class AddarticleIdToDataFile < ActiveRecord::Migration
  def up
    add_column :data_files, :article_id, :integer
  end

  def down
    remove_column :data_files, :article_id
  end
end
