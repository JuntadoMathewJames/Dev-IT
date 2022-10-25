class Subscription < ApplicationRecord
    has_one :point_of_sale, :dependent => :destroy
    
    validates :user_id, :payment, :dateOfPayment, presence:true
    validates :user_id, :payment, numericality:{greater_than:0}
end
