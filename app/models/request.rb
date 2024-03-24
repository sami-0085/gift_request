class Request < ApplicationRecord
  belongs_to :user
  has_many :choices, dependent: :destroy
  has_many :hints, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }

  def hint_by_number(number)
    hints.find_by(number: number).content
  end

  def choice_by_number(number)
    choices.find_by(number: number).content
  end
end
