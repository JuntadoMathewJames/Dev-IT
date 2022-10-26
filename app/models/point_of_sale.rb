class PointOfSale < ApplicationRecord
    has_many :transactions, :dependent => :destroy
    has_many :products, :dependent => :destroy
    has_many :sales, :dependent => :destroy

    validates :subscription_id, presence:true

end
