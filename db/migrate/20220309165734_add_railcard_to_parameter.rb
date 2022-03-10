class AddRailcardToParameter < ActiveRecord::Migration[6.1]
  def change
    add_column :parameters, :railcard, :boolean, default: false
  end
end
