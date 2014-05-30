class AddUserToFavorites < ActiveRecord::Migration
  def change
    add_reference :favorites, :user, index: true
  end
end
