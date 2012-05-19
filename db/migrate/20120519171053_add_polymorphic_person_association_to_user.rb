class AddPolymorphicPersonAssociationToUser < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.references :person, polymorphic: true
    end
  end

  def down
    remove_column :users, :person_id
    remove_column :users, :person_type
  end
end
