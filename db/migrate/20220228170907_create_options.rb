class CreateOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :options do |t|
      t.string :origin
      t.string :destination
      t.integer :cost
      t.datetime :start_time
      t.datetime :end_time
      t.time :duration
      t.references :paramter, null: false, foreign_key: true

      t.timestamps
    end
  end
end
