class AddApprovedToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_approved, :boolean
  end
end
