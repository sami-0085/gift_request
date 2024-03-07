class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.datetime :desired_date
      t.text :remarks
      t.integer :style
      t.string :title
      t.text :quest, null: false

      t.timestamps
    end
  end
end
