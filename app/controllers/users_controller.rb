class UsersController < ApplicationController
   def index
    @users = UsersWithLatestAccountsQuery.call

    @serialized_users = @users.map do |user|
      latest_account = user.latest_account_id && {
        bank: {
          name: user.bank_name,
          country: user.bank_country
        }
      }

      {
        name: user.user_name,
        latest_account: latest_account
      }
    end

    render json: @serialized_users
  end
end