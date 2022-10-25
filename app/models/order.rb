class Order < ApplicationRecord
    
    validates :transaction_id, :product_id, :quantity, :price, presence:true, numericality:{greater_than: 0}
end
