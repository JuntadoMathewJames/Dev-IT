module SalesHelper

    def isPaymentPresent
        payment = Payment.all.where("dateOfPayment = ?", Date.today())
        if payment.length > 0 
            return true
        else
            return false
        end
    end

    def isSaleRecordDuplicate
        pos_id = PosTracker.find_by(user_id: session[:user_id])
        sales = Sale.all.where("pos_id =?", pos_id.id)
        sales.each do |sale|
            if sale.dateOfSales == Date.today()
                return true
            end
        end

        return false
    end
end
