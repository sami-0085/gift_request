class User < ApplicationRecord
  authenticates_with_sorcery!
  has_one_attached :avatar do |attachable|
    attachable.variant :display, resize_to_limit: [200, 200]
  end
  has_many :requests, dependent: :destroy

  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, presence: true, uniqueness: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png],
                    message: "有効なフォーマットではありません" },
                    size: { less_than: 5.megabytes, message: " 5MBを超える画像はアップロードできません" }
  validates :reset_password_token, presence: true, uniqueness: true, allow_nil: true
end
