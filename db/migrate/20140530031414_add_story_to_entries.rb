class AddStoryToEntries < ActiveRecord::Migration
  def change
    add_reference :entries, :story, index: true
  end
end
