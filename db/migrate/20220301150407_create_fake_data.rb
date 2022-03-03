class CreateFakeDatas < ActiveRecord::Migration[6.1]
  def change
    create_table :fake_datas do |t|
      t.string :origin
      t.string :destination
      t.float :cost
      t.datetime :start_time
      t.datetime :end_time
      t.integer :duration
      t.string :mode

      t.timestamps
    end
  end
end
