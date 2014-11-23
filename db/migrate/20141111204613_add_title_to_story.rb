class AddTitleToStory < ActiveRecord::Migration
  def change
    add_column :stories, :title, :text
  end
end
