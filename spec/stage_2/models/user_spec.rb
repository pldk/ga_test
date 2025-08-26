require "rails_helper"

describe User, type: :model do
  describe "associations" do
    it "has many accounts" do
      user = described_class.create(name: "Test User")
      bank = Bank.create!(name: "Bank One", country: "US")
      account1 = Account.create!(user: user, bank:)
      account2 = Account.create!(user: user, bank:)

      expect(user.accounts).to include(account1, account2)
    end

    it "has many banks through accounts" do
      user = described_class.create!(name: "Test User")
      bank1 = Bank.create!(name: "Bank One", country: "US")
      bank2 = Bank.create!(name: "Bank Two", country: "FR")
      Account.create!(user: user, bank: bank1)
      Account.create!(user: user, bank: bank2)

      expect(user.banks).to include(bank1, bank2)
    end

    it "has_one latest_account" do
      user = described_class.create!(name: "Test User")
      bank1 = Bank.create!(name: "Bank One", country: "US")
      bank2 = Bank.create!(name: "Bank Two", country: "FR")
      Account.create!(user: user, bank: bank2)
      latest_account = Account.create!(user: user, bank: bank1)

      expect(user.latest_account).to eq(latest_account)
    end

    context "when destroying a user" do
      it "destroys associated accounts" do
        user = described_class.create!(name: "Test User")
        bank = Bank.create!(name: "Bank One", country: "US")
        account = Account.create!(user:, bank:)

        expect { user.destroy }.to change { Account.count }.by(-1)
        expect { account.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "does not destroy associated banks" do
        user = described_class.create!(name: "Test User")
        bank = Bank.create!(name: "Bank One", country: "US")
        Account.create!(user:, bank:)

        expect { user.destroy }.not_to change { Bank.count }
        expect(bank.reload).to be_present
      end
    end
  end
end
