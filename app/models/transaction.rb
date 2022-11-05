class Transaction < ApplicationRecord
    has_many :orders, :dependent => :destroy
    
    validates :pos_id, :dateOfTransaction, presence:true
    validates :pos_id, numericality:{greater_than:0}
    validates :totalPrice, presence:true, numericality:{greater_than:0}, on: :update
end
