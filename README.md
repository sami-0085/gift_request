# サービス名：GIFT_REQUEST(仮名)

## サービス概要
プレゼントして欲しいものがあるけど直接リクエストするのは言いづらいという方に
自分がプレゼントして欲しいものを謎解きにして
謎を解いてもらうことで欲しいものを伝えることができる、伝達アプリです。

## このサービスへの思い・作りたい理由
### プレゼント交換が苦手
誕生日やクリスマス、ちょっとしたお礼にと、プレゼントを貰う機会は意外と多くあります。
また相手に送るものも、毎年となるとネタも尽きてきてプレゼント探しが悩みの種に。
重複したものを渡してしまったり貰ったりしたことも。
しかし、直接欲しいものを言うのは味気ないしやりたくない。
### リクエスト×クエスト
GIFT_REQUESTは、こういったミスマッチや脱マンネリ化ができたらと思い考えました。
プレゼントして欲しいものを予め登録すると、謎解きクエストを作成することができます。
そしてプレゼントを送りたい人はそのクエストに挑戦します。
AIと対話しヒントをもらいながら読み解くことで、普段よりも楽しく、プレゼントを決めることができるはずです。

## ユーザー層について
プレゼントで何を送り合うか悩んでいる、プレゼント交換がマンネリ化している人同士

## サービスの利用イメージ
ユーザーが特定のプレゼントを登録し、プレゼント名を元にOPEN AIを利用して謎解きクエストを生成します。このクエストは物語形式で、プレゼントが伏せ字になっています。
プレゼントを送りたい人はこの謎を解き明かして、欲しいプレゼントを知ることができます。

クエストに挑戦する過程で、答え合わせをリアルタイムで行うことができ、クリアしたらその喜びをTwitterで共有することもできます。これにより、プレゼント選びが一人ではなく、友人や家族とのコミュニケーションの一環として楽しむことができるようになります。

このサービスを通じてユーザーは、プレゼント選びの新しい楽しみ方を発見でき、相手に対する思いやりやサプライズを演出する喜びも得られます。さらに、クエストを通じて自分の希望が叶えられます。

## ユーザーの獲得について
X(旧:Twitter)で告知してゲーム感覚で利用してもらう

## サービスの差別化ポイント
アプリに自分の欲しいものを登録しておき、ギフトを贈る人は、そのアプリ内で購入までできるアプリはありますが、
プレゼントして欲しいものを直接知らせるのではなく、謎解きにしたことが最大の違いです。
プレゼント選びという手間と時間のかかる作業を、謎解きの面白さと組み合わせることで（閃いた時や謎が解けた時の嬉しさ、非日常感）
その作業までも楽しめるような仕組みにしています。

## 実装を予定している機能
### MVP
- 会員登録
- ログイン/ログアウト機能
- クエスト一覧(index)
- プレゼント登録(create)
    - プレゼントを元にクエスト生成(OPEN AI利用)
    考え中の謎解き：
    プレゼント名を元にしたストーリー形式の謎を作成し、伏せ字（⚫︎⚫︎⚫︎）を当てる形式
    「自分が主人公でプレゼント名がキーワードとなるストーリーを起承転結に基づいて作成してください。
    なお、物語の中でキーワードを使用する場合は「⚫︎⚫︎⚫︎」としてください。例：「⚫︎⚫︎⚫︎は目的地をもたない」
- クエスト削除機能(delete)「本当に削除しますか？」
- クエスト挑戦
    - 答え合わせ機能（Ajax）
- クエストクリアをTwitterで投稿

### その後の機能
- ヒントをチャット形式で生成（アクションケーブル）
- ローディングの実装「クエストを生成中...」のようなメッセージの表示。
- クエスト招待機能
  「◯◯さんよりクエストの招待状が届きました」などの内容でLINEでリンクを送る機能

## 機能の実装方針予定
|カテゴリ|技術|
|:-------------|:------------|
|開発環境|Docker|
|フロントエンド|JavaScript　JQuery|
|バックエンド|Ruby 3.2.2 / Ruby on Rails 7系|
|データベース|PostgreSQL|
|インフラ|Render|
|Web API| Open AI API(GPT-4) |


## 画面遷移図
[画面遷移図](https://www.figma.com/file/gEFMyEx0QNwnjENitaVhOm/gift_request?type=design&node-id=0%3A1&mode=design&t=lq3JcScmWoDpdYl2-1)

## ER図
```mermaid
erDiagram
    Users {
        int user_id PK
        string name
        string email
        string crypted_password
        string salt
        string avatar
        datetime created_at
        datetime updated_at
    }

    Requests {
        int id PK
        int user_id FK
        string name
        datetime desired_date
        text remarks
        int style
        string title
        text quest
        datetime created_at
        datetime updated_at
    }

    Choices {
        int id PK
        int request_id FK
        int number
        text content
        datetime created_at
        datetime updated_at
    }

    Hints {
        int id PK
        int request_id FK
        int number
        text content
        datetime created_at
        datetime updated_at
    }

    USERS ||--o{ Requests : "1:n"
    Requests ||--o| Choices : "1:n"
    Requests ||--o| Hints : "1:n"

```