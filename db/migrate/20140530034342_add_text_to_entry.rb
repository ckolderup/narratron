class AddTextToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :text, :string
  end
end
