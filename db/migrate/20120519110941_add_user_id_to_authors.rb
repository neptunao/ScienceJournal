class AddUserIdToAuthors < ActiveRecord::Migration
  def up
    add_column :authors, :user_id, :integer
  end

  def down
    remove_column :authors, :user_id
  end
end
