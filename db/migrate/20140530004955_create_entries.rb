class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :parent_id
      t.string :parent_type

      t.timestamps
    end
  end
end
