class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :request
  has_many :messages
  validates :title, presence: true
end
