class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.integer :pos_id
      t.date :dateOfTransaction
      t.decimal :totalPrice

      t.timestamps
    end
  end
end
