class SalesController < ApplicationController
    before_action :is_subscribed
    before_action :is_logged_in
    def index
        removeUnfinishedSalesRecord
        @pos_id = PosTracker.find_by(user_id: session[:user_id])
        @sales = Sale.all.where("pos_id = ?", @pos_id.id)
        @page = params.fetch(:page, 0).to_i
        if  @page < 0 
        @page = 0
        end
        @sale_count = @sales.length()
        @sales_per_page = 5
        @sales = Sale.offset(@page * @sales_per_page).limit(@sales_per_page).where(pos_id: @pos_id.id).order(dateOfSales: :desc)
        
    end

    def search
        @pos_id = PosTracker.find_by(user_id: session[:user_id])
        search_type = params[:search_type].to_s
        search_type = "dateOfSales"
        @sales = Sale.where("#{search_type} LIKE ? ", "#{params[:search_value]}%").where(pos_id: @pos_id.id).order(dateOfSales: :desc)
        respond_to do |format|
          if @sales.length > 0
              format.turbo_stream{render turbo_stream: turbo_stream.update("sales",partial: "sales/search_results", locals:{sales:@sales })}
          elsif @sales.length <= 0
              format.turbo_stream{render turbo_stream: turbo_stream.update("sales","No Record/s Found")}
          end
        end
    end

    def new
        removeUnfinishedSalesRecord
        @sale = Sale.new
        @expense = Expense.new
    end

    def proceed
        pos_id = PosTracker.find_by(user_id: session[:user_id])
        sale = Sale.new
        sale.pos_id = pos_id.id
        sale.dateOfSales = params[:sale][:dateOfSales]
        sale.beginningBalance = params[:sale][:beginningBalance]
        sale.remarks = params[:sale][:remarks]
        payments = Payment.all.where("dateOfPayment =? ", sale.dateOfSales).where("pos_id = ?", pos_id.id)
        respond_to do |format|
            if payments.length() > 0
                if sale.save
                    format.html{redirect_to "/sales/#{sale.id}/add_expenses"}
                else
                    format.turbo_stream{render turbo_stream: turbo_stream.update("sale_input_area", partial: "sales/form", locals:{sale: sale})}
                end
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("errMsg", "Cannot generate a sales record. No Payments have been received on #{sale.dateOfSales}.")}
            end

        end
    end
    
    def expense_form
        @sale = Sale.find(params[:id])
        @expense = Expense.new
        @expenses = Expense.all.where("dateOfExpense = ?", @sale.dateOfSales).where("pos_id = ?", @sale.pos_id)
        if @sale.present?
            if @sale.netSales.present? && !@sale.beginningBalance.present?
                redirect_to "/sales"
            end
        else
            redirect_to "/sales"
        end

    end

    def save_expense
        sale = Sale.find(params[:id])
        expense =Expense.new
        expense.pos_id = sale.pos_id
        expense.dateOfExpense = sale.dateOfSales
        expense.description = params[:expense][:description]
        expense.amount = params[:expense][:amount]
        expenseDate = expense.dateOfExpense

        respond_to do |format|
            if expense.save
                expenses = Expense.all.where("dateOfExpense = ?", sale.dateOfSales).where("pos_id = ?", sale.pos_id)
                format.turbo_stream{render turbo_stream: turbo_stream.update("list_of_expenses_area",partial:"sales/display_expenses",locals:{expenses: expenses, expenseDate: expenseDate, sale: sale})}
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("expense_form_area",partial:"sales/form_for_expense",locals:{sale: sale, expense: expense})}
            end
        end
    end

    def generate_sale
        sale = Sale.find(params[:sale_id])
        expenses = Expense.all.where("dateOfExpense = ?",sale.dateOfSales).where("pos_id = ?",sale.pos_id)
        payments = Payment.all.where("dateOfPayment =? ",sale.dateOfSales).where("pos_id = ?",sale.pos_id)
        sale.grossSales = payments.sum(:amount)
        sale.netSales = (sale.grossSales + sale.beginningBalance) - expenses.sum(:amount)
        sale.save
        redirect_to "/sales"

    end

    def view
        @sale = Sale.find(params[:id])
        @expenses = Expense.all.where("dateOfExpense = ?",@sale.dateOfSales).where("pos_id = ?",@sale.pos_id)
        @payments = Payment.all.where("dateOfPayment = ?", @sale.dateOfSales).where("pos_id = ?",@sale.pos_id)
    end

    def destroy
        sale = Sale.find(params[:id])
        expenses = Expense.all.where("dateOfExpense = ?",sale.dateOfSales).where("pos_id = ?", sale.pos_id)
        expenses.each do |expense|
            expense.destroy
        end
        sale.destroy
        redirect_to "/sales"
    end

    def destroy_expense
        sale = Sale.find(params[:sale_id])
        expense = Expense.find(params[:id])
        expense.destroy
        expenses = Expense.all.where("dateOfExpense = ?",sale.dateOfSales).where("pos_id =? ",sale.pos_id)
        expenseDate = sale.dateOfSales
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("list_of_expenses_area",partial:"sales/display_expenses",locals:{expenses: expenses, expenseDate: expenseDate, sale: sale})}
        end
    end


    private

    def removeUnfinishedSalesRecord
        pos_id = PosTracker.find_by(user_id: session[:user_id])
        sales = Sale.all.where("pos_id =?",pos_id.id)
        sales.each do |sale|
            if sale.netSales == "" || sale.netSales == nil
                expenses = Expense.all.where("dateOfExpense = ?", sale.dateOfSales).where("pos_id = ?",sale.pos_id)
                expenses.each do |expense|
                    expense.destroy
                end
                sale.destroy
            end
        end
    end
end
