class AddSellCountToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :sell_count, :integer
  end
end
