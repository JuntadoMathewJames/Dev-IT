class Product < ApplicationRecord

    validates :pos_id, :productName, :quantity, :pricePerUnit,:product_type, presence:true
    validates :quantity, numericality:{greater_than: -1}
    validates :pricePerUnit, numericality:{greater_than: 0}
    validates :productName, uniqueness:true
    validates :retail_price, presence:true, numericality:{greater_than: 0}

end
