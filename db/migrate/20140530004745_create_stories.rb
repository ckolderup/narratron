class CreateStories < ActiveRecord::Migration
  def change
    create_table :stories do |t|
      t.string :thanks

      t.timestamps
    end
  end
end
