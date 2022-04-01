class CreateResults < ActiveRecord::Migration[6.1]
  def change
    create_table :results do |t|
      t.string :origin
      t.string :destination
      t.datetime :start_time
      t.datetime :end_time
      t.integer :duration
      t.string :mode

      t.timestamps
    end
  end
end
