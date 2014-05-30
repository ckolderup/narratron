class AddPathToFavorites < ActiveRecord::Migration
  def change
    add_reference :favorites, :path, index: true
  end
end
