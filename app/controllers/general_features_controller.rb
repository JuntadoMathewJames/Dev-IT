class GeneralFeaturesController < ApplicationController
    before_action :set_current_url, except:[:pos]
    before_action :is_subscribed, only: %i[pos]
    before_action :is_logged_in
    def index
    
    end

    def pos
      
    end

    def account_details
        @method = params[:method]
        if @method == "statistics"
            if session[:user_status] == "SUBSCRIBED"
            @pos_id = PosTracker.find_by("user_id = ?",session[:user_id])
            @transactions = Transaction.all.where("pos_id =? ", @pos_id.id)
            @products = Product.all.where("pos_id =?", @pos_id.id)
            @sales = Sale.all.where("pos_id =?",@pos_id.id)
            @expenses = Expense.all.where("pos_id = ?",@pos_id.id)
            @payments = Payment.all.where("pos_id = ?",@pos_id.id)
            else
               
               redirect_to "/account_details/subscribe"
            end

        end
    end

 

end
