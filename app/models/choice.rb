class Choice < ApplicationRecord
  belongs_to :request

  enum number: {
    choice1: 1,
    choice2: 2,
    choice3: 3
  }

  validates :number, presence: true
  validates :content, presence: true

  # contentにテキストを設定する前に呼び出されるメソッド
  before_save :set_content

  private

  # numberの値に基づいてcontentフィールドにテキストを設定
  def set_content
    case number
    when "choice1"
      self.content = "ここにchoice1に対応するテキストを設定"
    when "choice2"
      self.content = "ここにchoice2に対応するテキストを設定"
    when "choice3"
      self.content = "ここにchoice3に対応するテキストを設定"
    end
  end
end
