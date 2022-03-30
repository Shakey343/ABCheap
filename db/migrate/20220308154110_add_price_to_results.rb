class AddPriceToResults < ActiveRecord::Migration[6.1]
  def change
    add_monetize :results, :price, currency: { present: false }
  end
end
