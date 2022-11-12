class Order < ApplicationRecord
    validates :transaction_id, :product_id, :quantity, presence:true, numericality:{greater_than: 0}
    validate :checkProductQuantity
    def checkProductQuantity
        if (product_id != nil || product_id != "") && (quantity != nil)
            product = Product.find(product_id) 
            if product.quantity - quantity < 0
                errors.add(:quantity , "Order Quantity cannot exceed the remaining quantity of the product.")
            end
        end
    end
end
