class CreatePointOfSales < ActiveRecord::Migration[7.0]
  def change
    create_table :point_of_sales do |t|
      t.integer :subscription_id

      t.timestamps
    end
  end
end
