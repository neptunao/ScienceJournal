class CreateJournals < ActiveRecord::Migration
  def up
    create_table :journals do |t|
      t.string :name, null: false
      t.integer :num, null: false, default: 1
      t.integer :category_id

      t.timestamps
    end
  end

  def down
    drop_table :journals
  end
end
