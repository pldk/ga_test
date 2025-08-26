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
      Account.insert_all(10_000.times.map { { user_id: user_ids.sample, bank_id: bank_ids.sample } })
      expect { get users_path }.to perform_under(50).ms.warmup(2).times.sample(10).times
    end

    it "returns users and associated accounts", :aggregate_failures do
      user = User.create!(name: "Test User")
      bank = Bank.create!(name: "ABN AMRO FUND MANAGERS LIMITED", country: "Eritrea")
      Account.create!(user: user, bank: bank)

      get users_path

      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      parsed_body = response.parsed_body
      expect(parsed_body).to be_an(Array)
      expect(parsed_body.size).to eq(1)
      expect(parsed_body.first.keys).to eq(%w[name latest_account])
      expect(parsed_body.dig(0, "name")).to eq(user.name)
      expect(parsed_body.dig(0, "latest_account")).to be_an(Hash)
      expect(parsed_body.dig(0, "latest_account").keys).to eq(%w[bank])
      expect(parsed_body.dig(0, "latest_account", "bank")).to be_a(Hash)
      expect(parsed_body.dig(0, "latest_account", "bank", "name")).to eq(bank.name)
      expect(parsed_body.dig(0, "latest_account", "bank", "country")).to eq(bank.country)
      expect(parsed_body).to eq(
                               [
                                 {
                                   "name" => user.name,
                                   "latest_account" =>
                                     {
                                       "bank" => {
                                         "name" => bank.name,
                                         "country" => bank.country
                                       }
                                     }
                                 }
                               ]
                             )
    end
  end
end
