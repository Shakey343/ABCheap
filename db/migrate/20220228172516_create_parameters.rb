class CreateParameters < ActiveRecord::Migration[6.1]
  def change
    create_table :parameters do |t|
      t.string :origin
      t.string :destination
      t.references :user_id, null: false, foreign_key: true
      t.datetime :prefered_start
      t.datetime :earliest_start
      t.datetime :latest_finish

      t.timestamps
    end
  end
end
