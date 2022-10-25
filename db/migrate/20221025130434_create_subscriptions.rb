class CreateSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.decimal :payment
      t.date :dateOfPayment

      t.timestamps
    end
  end
end
