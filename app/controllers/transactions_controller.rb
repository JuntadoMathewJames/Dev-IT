class TransactionsController < ApplicationController
    before_action :is_subscribed
    before_action :is_logged_in

    def index
        deleteUnfinishedTransactions
        @pos_id = PosTracker.find_by(user_id: session[:user_id])
        @page = params.fetch(:page, 0).to_i
        if  @page < 0 
        @page = 0
        end
        @transactions = Transaction.all.where("pos_id = ?", @pos_id.id).where(status: "PAID")
        @transaction_count = @transactions.length()
        @transactions_per_page = 5
        @transactions = Transaction.offset(@page * @transactions_per_page).limit(@transactions_per_page).order(:dateOfTransaction).where(pos_id: @pos_id.id).where(status: "PAID")
       
    end

    def search
        @pos_id = PosTracker.find_by(user_id: session[:user_id])
        search_type = params[:search_type].to_s
        search_type = "dateOfTransaction"
        @transactions = Transaction.where("#{search_type} LIKE ? ", "#{params[:search_value]}%").where(pos_id: @pos_id.id).where(status: "PAID").order(:dateOfTransaction)
        respond_to do |format|
          if @transactions.length > 0
              format.turbo_stream{render turbo_stream: turbo_stream.update("transactions",partial: "transactions/search_results", locals:{transactions:@transactions })}
          elsif @transactions.length <= 0
              format.turbo_stream{render turbo_stream: turbo_stream.update("transactions","No Record/s Found")}
          end
        end
    end

    def new
        deleteUnfinishedTransactions
        @pos_id = PosTracker.find_by(user_id: session[:user_id])
        @transaction = Transaction.new
        @transaction.pos_id = @pos_id.id
        @transaction.dateOfTransaction = Date.today()
        @transaction.status = "UNFINISHED"
        @transaction.save
        @order = Order.new
         
    end

    def view
        @transaction = Transaction.find(params[:id])
        @orders = Order.all.where("transaction_id = ?",@transaction.id)
        @order_count = @orders.length()
        @page = params.fetch(:page, 0).to_i
        if @page < 0 
        @page = 0
        end
        @orders_per_page = 5
        @orders = Order.offset(@page * @orders_per_page).limit(@orders_per_page).where(transaction_id: @transaction.id)
      
    end

    def save_order
        pos_id = PosTracker.find_by(user_id: session[:user_id])
        order = nil
        if params[:order_id].present?
            puts "hello"
            order = Order.find(params[:order_id])
        else
            order = Order.new
        end
        order.transaction_id = params[:order][:transaction_id]
        order.product_id = params[:order][:product_id]
        order.quantity = params[:order][:quantity]

        respond_to do |format|
            if order.valid?
                product = Product.find(params[:order][:product_id])
                order.price = product.pricePerUnit.to_i * order.quantity.to_i
                product.quantity -= order.quantity
                product.save
                order.save
                orders = Order.all.where(transaction_id: params[:order][:transaction_id])
                format.turbo_stream{render turbo_stream: turbo_stream.update("cart", partial: "cart", locals:{orders: orders,transaction_id: order.transaction_id})}
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("transactions", partial: "form", locals:{transaction: params[:order][:transaction_id] ,pos_id: pos_id.id, order: order })}
               
            end
        end
    end


    def create
        transaction = Transaction.find(params[:transaction_id])
        respond_to do |format|
            if transaction.totalPrice.present?
                transaction.status = "PAID"
                transaction.save
                payment = Payment.new
                payment.dateOfPayment = Date.today()
                payment.amount = transaction.totalPrice
                payment.pos_id = transaction.pos_id
                payment.save
                format.html{redirect_to "/transactions"}
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("errMsg","Transaction is not yet paid.")}
            end
        end
    end


    def payment
        transaction = Transaction.find(params[:transaction_id])
        respond_to do |format|
            if params[:payment].to_i >= params[:totalPrice].to_i
                transaction.totalPrice = params[:totalPrice]
                transaction.save
                change_value = params[:payment].to_i - params[:totalPrice].to_i 
                format.turbo_stream{render turbo_stream: turbo_stream.update("change_field","<input type='number' id = 'change' name = 'change' class = 'form-control' disabled = 'disabled' value = #{change_value}>")}
            elsif params[:payment].to_i < params[:totalPrice].to_i
                transaction.totalPrice = nil
                transaction.save
                format.turbo_stream{render turbo_stream: turbo_stream.update("change_field","<p style = 'color:red'>Payment must be greater than or equals Total Price.</p>")}
            elsif params[:payment] == nil || params[:payment] == ""
                format.turbo_stream{render turbo_stream: turbo_stream.update("change_field","<input type='number' id = 'change' name = 'change' class = 'form-control' disabled = 'disabled'")}
            end
        end
    end


    def delete #delete order
        order = Order.find(params[:id])
        transaction = Transaction.find(order.transaction_id)
        product = Product.find(order.product_id)
        product.quantity += order.quantity
        product.save
        order.destroy
        respond_to do |format|
            orders = Order.all.where("transaction_id = ?",transaction.id)
            format.turbo_stream{render turbo_stream: turbo_stream.update("cart", partial: "cart", locals:{orders: orders})}
        end
    end

    def destroy #delete transaction
        transaction = Transaction.find(params[:id])
        transaction.destroy
        redirect_to "/transactions"
    end

    private

    def deleteUnfinishedTransactions
        pos_id = PosTracker.find_by(user_id: session[:user_id])
        transactions = Transaction.all.where(pos_id: pos_id.id)
        transactions.each do |transaction|
            if transaction.status == "UNFINISHED"
                orders = Order.all.where("transaction_id = ?",transaction.id)
                if orders.present?
                    orders.each do |order|
                        product = Product.find(order.product_id)
                        product.quantity += order.quantity
                        product.save
                    end
                end
                transaction.destroy
            end
        end
    end
end
