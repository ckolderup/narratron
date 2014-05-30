class CreatePaths < ActiveRecord::Migration
  def change
    create_table :paths do |t|

      t.timestamps
    end
  end
end
