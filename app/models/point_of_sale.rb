class PointOfSale < ApplicationRecord
    has_many :transaction, :dependent => :destroy
    has_many :product, :dependent => :destroy
    has_many :sale, :dependent => :destroy

    validates :subscription_id, presence:true

end
