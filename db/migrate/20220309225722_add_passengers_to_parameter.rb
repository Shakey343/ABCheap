class AddPassengersToParameter < ActiveRecord::Migration[6.1]
  def change
    add_column :parameters, :passengers, :string
  end
end
