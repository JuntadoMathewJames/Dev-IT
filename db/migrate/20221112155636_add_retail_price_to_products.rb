class AddRetailPriceToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :retail_price, :decimal
  end
end
