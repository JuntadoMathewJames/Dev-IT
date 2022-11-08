class AddPosIdToExpenses < ActiveRecord::Migration[7.0]
  def change
    add_column :expenses, :pos_id, :integer
  end
end
