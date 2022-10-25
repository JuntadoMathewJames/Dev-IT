class Expense < ApplicationRecord

    validates :amount, :dateOfExpense, presence:true
    
end
