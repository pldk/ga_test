require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get users_path
      expect(response).to have_http_status(:success)
    end

    it "ensures a strict_loading check" do
      allow(User).to receive(:strict_loading).and_call_original
      get users_path
      expect(User).to have_received(:strict_loading)
    end

    it "performs a query under xx ms" do
      bank_ids = Bank.insert_all(250.times.map { { name: Faker::Bank.name, country: Faker::Address.country } }, returning: :id).rows.flatten
      user_ids = User.insert_all(100.times.map { { name: Faker::Name.name } }, returning: :id).rows.flatten
      Account.insert_all(1000.times.map { { user_id: user_ids.sample, bank_id: bank_ids.sample } })
      expect { get users_path }.to perform_under(50).ms.warmup(2).times.sample(10).times
    end
  end
end
