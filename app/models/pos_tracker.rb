class PosTracker < ApplicationRecord
    has_many :transactions, :dependent => :destroy
    has_many :products, :dependent => :destroy
    has_many :sales, :dependent => :destroy

    validates :user_id, uniqueness: true, presence:true, numericality:{greater_than: 0}

end
