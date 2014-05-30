class AddStoryToPaths < ActiveRecord::Migration
  def change
    add_column :paths, :story, :reference
  end
end
