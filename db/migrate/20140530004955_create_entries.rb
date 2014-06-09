class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :spawnable_id
      t.string :spawnable_type

      t.timestamps
    end
  end
end
