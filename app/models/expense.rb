class Expense < ApplicationRecord

    validates :amount, :dateOfExpense, :description,presence:true
    validates :amount, numericality:{greater_than: 0}
    
end
