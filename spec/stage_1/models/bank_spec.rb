require "rails_helper"

describe Bank do
  describe "associations" do
    it "returns accounts associated with the bank" do
      bank = Bank.create!(name: "Test Bank", country: "US")
      user1 = User.create!(name: "User One")
      user2 = User.create!(name: "User Two")
      account1 = Account.create!(user: user1, bank: bank)
      account2 = Account.create!(user: user2, bank: bank)

      expect(bank.accounts).to include(account1, account2)
    end

    context "when destroying a bank" do
      it "destroys associated accounts" do
        bank = Bank.create!(name: "Test Bank", country: "US")
        user = User.create!(name: "User One")
        account = Account.create!(user: user, bank: bank)

        expect { bank.destroy }.to change { Account.count }.by(-1)
        expect { account.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe ".users" do
    it "returns users associated with the bank" do
      bank = Bank.create!(name: "Test Bank", country: "US")
      user1 = User.create!(name: "User One")
      user2 = User.create!(name: "User Two")
      Account.create!(user: user1, bank: bank)
      Account.create!(user: user2, bank: bank)

      expect(bank.users).to include(user1, user2)
    end

    context "when destroying a bank" do
      it "does not destroy associated users" do
        bank = Bank.create!(name: "Test Bank", country: "US")
        user = User.create!(name: "User One")
        Account.create!(user: user, bank: bank)

        expect { bank.destroy }.not_to change { User.count }
        expect(user.reload).to be_present
      end
    end
  end

  describe "validations" do
    it "validates presence of name" do
      bank = Bank.new(country: "US")
      expect(bank).not_to be_valid
      expect(bank.errors[:name]).to include("can't be blank")
    end

    it "validates presence of country" do
      bank = Bank.new(name: "Test Bank")
      expect(bank).not_to be_valid
      expect(bank.errors[:country]).to include("can't be blank")
    end
  end
end
