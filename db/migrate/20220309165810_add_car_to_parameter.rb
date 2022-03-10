class AddCarToParameter < ActiveRecord::Migration[6.1]
  def change
    add_column :parameters, :car, :boolean, default: false
  end
end
