class Sale < ApplicationRecord
    
    validates :pos_id, :dateOfSales, :netSales, :grossSales, :beginningBalance, :remarks, presence:true
    validates :pos_id, :grossSales, :beginningBalance, numericality:{greater_than: -1}
    validates :netSales, numericality:{true}

end
