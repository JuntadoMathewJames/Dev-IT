class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.integer :pos_id
      t.string :productName
      t.decimal :quantity
      t.decimal :pricePerUnit

      t.timestamps
    end
  end
end
