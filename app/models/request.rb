class Request < ApplicationRecord
  belongs_to :user
  has_many :choices, dependent: :destroy
  has_many :hints, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
end
