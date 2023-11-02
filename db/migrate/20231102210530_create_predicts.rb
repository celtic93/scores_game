class CreatePredicts < ActiveRecord::Migration[7.0]
  def change
    create_table :predicts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true
      t.string :score

      t.timestamps
    end
  end
end
