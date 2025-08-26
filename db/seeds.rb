if Bank.exists?
  bank_ids = Bank.pluck(:id)
  puts "Banks already exist, skipping creation."
else
  puts "Creating Banks..."
  bank_ids = Bank.insert_all(250.times.map { { name: Faker::Bank.name, country: Faker::Address.country } }, returning: :id).rows.flatten
  puts "Created #{bank_ids.size} Banks"
end

unless User.exists?
  puts "Create Users..."
  user_ids = User.insert_all(10.times.map { { name: Faker::Name.name } }, returning: :id).rows.flatten
  puts "Created #{user_ids.size} Users"
else
  user_ids = User.pluck(:id)
  puts "Users already exist, skipping creation."
end

if defined?(Account) && !Account.exists?
  puts "Create Accounts..."
  Account.insert_all(100.times.map { { user_id: user_ids.sample, bank_id: bank_ids.sample } })
  puts "Created #{Account.count} Accounts"
else
  puts "Accounts already exist, skipping creation."
end


if defined?(Account) && !Account.exists? && ENV["COMPLEXITY_LEVEL"] == "madness"
  puts "Creating 1,000,000 Accounts for madness complexity level..."
  Account.insert_all(1_000_000.times.map { { user_id: user_ids.sample, bank_id: bank_ids.sample } })
  puts "Created #{Account.count} Accounts"
else
  puts "Skipping creation of 1,000,000 Accounts as they already exist or complexity level is not madness."
end
