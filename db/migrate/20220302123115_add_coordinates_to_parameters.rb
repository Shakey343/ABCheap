class AddCoordinatesToParameters < ActiveRecord::Migration[6.1]
  def change
    add_column :parameters, :latitude, :float
    add_column :parameters, :longitude, :float
  end
end
