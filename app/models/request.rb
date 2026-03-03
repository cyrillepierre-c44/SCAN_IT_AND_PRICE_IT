class Request < ApplicationRecord
  @cleanliness = ["Très propre", "Propre", "Sale", "Très sale"]

  has_many :chats, dependent: :destroy

  validates :cleanliness, presence: true, inclusion: { in: @cleanliness }
  validates :fullness, presence: true
  validates :newness, presence: true

  has_one_attached :photo
end
