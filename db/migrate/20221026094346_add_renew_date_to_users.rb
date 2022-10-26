class AddRenewDateToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :renewDate, :date
  end
end
