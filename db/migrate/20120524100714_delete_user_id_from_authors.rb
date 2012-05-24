class DeleteUserIdFromAuthors < ActiveRecord::Migration
  def up
    remove_column :authors, :user_id
  end

  def down
    add_column :authors, :user_id, :integer
  end
end
