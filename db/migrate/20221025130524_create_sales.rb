class CreateSales < ActiveRecord::Migration[7.0]
  def change
    create_table :sales do |t|
      t.integer :pos_id
      t.date :dateOfSales
      t.decimal :netSales
      t.decimal :grossSales
      t.decimal :beginningBalance
      t.string :remarks

      t.timestamps
    end
  end
end
