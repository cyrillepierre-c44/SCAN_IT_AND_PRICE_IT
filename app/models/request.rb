class Request < ApplicationRecord
  @cleanliness = ["Très propre", "Propre", "Sale", "Très sale"]

  has_many :chats, dependent: :destroy

  validates :cleanliness, presence: true, inclusion: { in: @cleanliness }
  validates :fullness, inclusion: { in: [true, false] }
  validates :newness, inclusion: { in: [true, false] }

  has_one_attached :photo
end
