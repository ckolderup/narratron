class AddChildrenToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :parent_id, :reference
  end
end
