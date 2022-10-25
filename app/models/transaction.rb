class Transaction < ApplicationRecord

    validates :pos_id, :dateOfTransaction, :totalPrice, presence:true
    validates :pos_id, :totalPrice, numericality:{greater_than:0}
end
