class AddStoryCreatorToUser < ActiveRecord::Migration
  def change
    add_column :users, :story_creator, :boolean, default: false
  end
end
