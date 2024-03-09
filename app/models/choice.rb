class Choice < ApplicationRecord
  belongs_to :request

  enum number: {
    choice1: 1,
    choice2: 2,
    choice3: 3
  }

  validates :number, presence: true
  validates :content, presence: true
end
