class AddBanksAndUsersToAccounts < ActiveRecord::Migration[7.2]
  def change
    add_reference :accounts, :user, null: false, foreign_key: true
    add_reference :accounts, :bank, null: false, foreign_key: true
  end
end
