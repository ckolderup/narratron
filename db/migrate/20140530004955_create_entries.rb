class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|

      t.timestamps
    end
  end
end
