class AddBookedToResults < ActiveRecord::Migration[6.1]
  def change
    add_column :results, :booked, :boolean, default: false
  end
end
