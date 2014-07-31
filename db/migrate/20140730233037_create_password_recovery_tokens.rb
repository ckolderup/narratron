class CreatePasswordRecoveryTokens < ActiveRecord::Migration
  def change
    create_table :password_recovery_tokens do |t|
      t.references :user, index: true
      t.string :token

      t.timestamps
    end
  end
end
