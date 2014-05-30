class AddPathToVotes < ActiveRecord::Migration
  def change
    add_reference :votes, :path, index: true
  end
end
