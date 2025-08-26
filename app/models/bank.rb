class Bank < ApplicationRecord
  has_many :accounts, dependent: :destroy
  has_many :users, through: :accounts

  validates :country, :name, presence: true
end
