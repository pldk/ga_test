class UsersWithLatestAccountsQuery
  def self.call
    latest_accounts_sql = <<-SQL.squish
      SELECT DISTINCT ON (user_id) *
      FROM accounts
      ORDER BY user_id, created_at DESC
    SQL

    User
      .strict_loading
      .joins("LEFT JOIN (#{latest_accounts_sql}) AS latest_accounts ON latest_accounts.user_id = users.id")
      .joins("LEFT JOIN banks ON banks.id = latest_accounts.bank_id")
      .select(
        "users.id AS user_id",
        "users.name AS user_name",
        "latest_accounts.id AS latest_account_id",
        "banks.name AS bank_name",
        "banks.country AS bank_country"
      )
  end
end