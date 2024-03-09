class CreateChoices < ActiveRecord::Migration[7.0]
  def change
    create_table :choices do |t|
      t.references :request, null: false, foreign_key: true
      t.integer :number, null: false
      t.text :content, null: false

      t.timestamps
    end
  end
end
