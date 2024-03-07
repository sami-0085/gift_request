class Hint < ApplicationRecord
  belongs_to :request

  enum number: {
    hint1: 1,
    hint2: 2,
    hint3: 3
  }

  validates :number, presence: true
  validates :content, presence: true

  # contentにテキストを設定する前に呼び出されるメソッド
  before_save :set_content

  private

  # numberの値に基づいてcontentフィールドにテキストを設定
  def set_content
    case number
    when "hint1"
      self.content = "ここにhint1に対応するテキストを設定"
    when "hint2"
      self.content = "ここにhint2に対応するテキストを設定"
    when "hint3"
      self.content = "ここにhint3に対応するテキストを設定"
    end
  end
end
