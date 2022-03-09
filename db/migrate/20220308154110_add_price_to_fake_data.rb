class AddPriceToFakeData < ActiveRecord::Migration[6.1]
  def change
    add_monetize :fake_data, :price, currency: { present: false }
  end
end
