class AddBookedToFakeData < ActiveRecord::Migration[6.1]
  def change
    add_column :fake_data, :booked, :boolean, default: false
  end
end
