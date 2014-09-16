class ChangeSubmissionTextFieldType < ActiveRecord::Migration
  def change
    change_column :submissions, :text, :text, :limit => nil
  end
end
