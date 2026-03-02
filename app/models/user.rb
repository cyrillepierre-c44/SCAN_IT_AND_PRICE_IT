class User < ApplicationRecord
  has_many :chats
  has_many :messages, through: :chats
  has_many :requests, through: :chats
  validates :email, presence: true, format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\z/ }
  validates :password, presence: true, length: { minimum: 6 }
end
