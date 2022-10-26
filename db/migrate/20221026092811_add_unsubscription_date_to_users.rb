class AddUnsubscriptionDateToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :unsubscriptionDate, :date
  end
end
