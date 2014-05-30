class AddStoryToDay < ActiveRecord::Migration
  def change
    add_reference :days, :story, index: true
  end
end
