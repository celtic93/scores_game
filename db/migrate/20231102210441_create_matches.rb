class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.references :round, null: false, foreign_key: true
      t.string :home_team
      t.string :guest_team
      t.string :result
      t.string :status
      t.datetime :date_time
      t.string :link_path

      t.timestamps
    end
  end
end
