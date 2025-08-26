require "rails_helper"

describe Account, type: :model do
  describe "associations" do
    it "belongs to a user" do
      user = User.create!(name: "Test User")
      bank = Bank.create!(name: "Test Bank", country: "US")
      account = Account.new(user: user, bank: bank)

      expect(account.user).to eq(user)
    end

    it "belongs to a bank" do
      user = User.create!(name: "Test User")
      bank = Bank.create!(name: "Test Bank", country: "US")
      account = Account.new(user: user, bank: bank)

      expect(account.bank).to eq(bank)
    end

    context "when destroying an account" do
      it "does not destroy the associated user" do
        user = User.create!(name: "Test User")
        bank = Bank.create!(name: "Test Bank", country: "US")
        account = Account.create!(user: user, bank: bank)

        expect { account.destroy }.not_to change { User.count }
        expect(user.reload).to be_present
      end

      it "does not destroy the associated bank" do
        user = User.create!(name: "Test User")
        bank = Bank.create!(name: "Test Bank", country: "US")
        account = Account.create!(user: user, bank: bank)

        expect { account.destroy }.not_to change { Bank.count }
        expect(bank.reload).to be_present
      end
    end
  end
end
