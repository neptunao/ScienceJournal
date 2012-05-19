class CreateCensors < ActiveRecord::Migration
  def change
    create_table :censors do |t|
      t.string :first_name, null: false
      t.string :middle_name
      t.string :last_name, null: false
      t.string :degree, null: false
      t.string :post, null: false

      t.timestamps
    end
  end
end
