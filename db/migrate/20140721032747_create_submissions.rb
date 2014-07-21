class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.string :text
      t.string :title
      t.string :author

      t.timestamps
    end
  end
end
