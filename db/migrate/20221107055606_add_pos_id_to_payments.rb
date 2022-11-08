class AddPosIdToPayments < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :pos_id, :integer
  end
end
