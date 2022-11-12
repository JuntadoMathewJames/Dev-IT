class Sale < ApplicationRecord
    
    validates :pos_id, :dateOfSales, :beginningBalance, presence:true
    validates :pos_id, :beginningBalance, numericality:{greater_than: -1}
    validates :grossSales, numericality:{greater_than: -1}, presence:true, on: :update
    validates :netSales, numericality:true, presence:true, on: :update
    validates :dateOfSales, uniqueness: true
end
