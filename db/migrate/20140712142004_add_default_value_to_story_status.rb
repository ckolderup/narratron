class AddDefaultValueToStoryStatus < ActiveRecord::Migration
  def change
    change_column :stories, :status, :int, :default => 0
  end
end
