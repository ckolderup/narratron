class AddEndingToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :ending, :boolean
  end
end
