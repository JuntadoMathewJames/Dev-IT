class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :transaction_id
      t.integer :product_id
      t.decimal :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
