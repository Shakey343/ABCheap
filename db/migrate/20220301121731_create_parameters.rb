class CreateParameters < ActiveRecord::Migration[6.1]
  def change
    create_table :parameters do |t|
      t.string :origin
      t.string :destination
      t.datetime :preferred_start
      t.datetime :earliest_start
      t.datetime :latest_finish

      t.timestamps
    end
  end
end
