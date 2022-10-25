class Payment < ApplicationRecord

    validates :dateOfPayment, :amount, presence:true
end
