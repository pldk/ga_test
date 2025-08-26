class User < ApplicationRecord
  has_many :accounts, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :banks, through: :accounts

  # this relationship breaks the query with the latest account combined with the order scope
  # has_one :latest_account, -> { order(created_at: :desc) }, class_name: 'Account'

  def latest_account
    accounts.first
  end
end
