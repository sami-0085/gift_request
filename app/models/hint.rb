class Hint < ApplicationRecord
  belongs_to :request

  enum number: {
    hint1: 1,
    hint2: 2,
    hint3: 3
  }

  validates :number, presence: true
  validates :content, presence: true
end
