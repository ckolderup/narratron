class ChangeTypeOfEntryTextField < ActiveRecord::Migration
  def change
    change_column :entries, :text, :text, :limit => nil
  end
end
