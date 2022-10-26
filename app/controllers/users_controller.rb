class UsersController < ApplicationController
    before_action :is_logged_in, only: %i[subscribe subscribe_proceed]
    before_action :set_current_url

    def index

    end

    def logout
        session[:user_id] = nil
        session[:user_status] = nil
        redirect_to "/login"
    end

    def login_proceed
        user = User.find_by(username: params[:username])
        respond_to do |format|
            if user.present?
                if user.authenticate(params[:password])
                    session[:user_id] = user.id
                    session[:user_status] = user.status
                    checkUserUnsubscriptionDate
                    checkUserRenewalDate
                    if user.status == "UNSUBSCRIBED"
                        format.html{redirect_to "/account_details/subscribe"}
                    else
                        format.html{redirect_to "/pos"}
                    end
                else
                    format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea", "<ul><li id = 'errMsg' style = 'color:red;'>INCORRECT PASSWORD!</li></ul>")}
                end
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("login_errorArea", "<ul><li id = 'errMsg' style = 'color:red;'>ACCOUNT NOT FOUND!</li></ul>")}
            end
        end
    end

    def register_proceed
        @user = User.new
        @user.username = params[:register_username]
        @user.password_digest = params[:password_digest]
        @user.status = "UNSUBSCRIBED"
        respond_to do |format|
            if @user.valid?
                if @user.password_digest == params[:confirm_password]
                    @user.password_digest = BCrypt::Password.create(@user.password_digest)
                    @user.save
                    session[:user_id] = @user.id
                    session[:user_status] = @user.status
                    format.html{redirect_to "/account_details/subscribe"}
                else
                    format.turbo_stream{render turbo_stream: turbo_stream.update("register_errorArea", "<p style = 'color:red;'><strong>Passwords did not match!</strong></p>")}
                end
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("register_errorArea",partial: "/layouts/errorMessage", locals:{entity: @user})}
            end
        end
    end

    def subscribe_proceed
        @subscription = Subscription.new
        @point_of_sale = PointOfSale.new
        @subscription.user_id = params[:user_id]
        @subscription.payment = params[:payment]
        @subscription.dateOfPayment = params[:dateOfPayment]
        user = User.find(params[:user_id])
        respond_to do |format|
            if user.authenticate(params[:confirm_password])
                user.status = "SUBSCRIBED"
                user.save
                session[:user_status]= user.status
                @subscription.save
                @point_of_sale.subscription_id = @subscription.id
                @point_of_sale.save
                format.html{redirect_to "/pos"}
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("errorArea","<p style = 'color:red;'><strong>Incorrect Password!</strong></p>")}
            end
        end
    end

    def cancel_subscription
        user = User.find(params[:user_id])
        subscriptions = Subscription.all.where("user_id = ? ", user.id)
        respond_to do |format|
            if user.authenticate(params[:confirm_password])
                user.unsubscriptionDate = subscriptions.last.dateOfPayment + 30
                user.renewDate = nil
                if Date.today() == user.unsubscriptionDate
                    user.status = "UNSUBSCRIBED"
                    session[:user_status] = user.status
                end
                user.save
                format.html{redirect_to "/account_details/subscribe"}
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("errMsg","Incorrect Password!")}
            end
            
        end
    end

    def renew_subscription
        user = User.find(params[:user_id])
        user.renewDate = user.unsubscriptionDate + 30
        respond_to do |format|
            if user.renewDate== Date.today()
                subscription = Subscription.new
                subscription.user_id = user.id
                subscription.payment = 60
                subscription.dateOfPayment = Date.today()
                subscription.save
                user.status = "SUBSCRIBED"
                session[:user_status] = user.status
                user.unsubscriptionDate = nil
                user.renewDate = nil
                user.save
                format.html{redirect_to "/account_details/subscribe"}
            else
                user.unsubscriptionDate = nil
                user.save
                format.html{redirect_to "/account_details/subscribe"}
            end
        end
    end

    def change_password
        @user = User.find(params[:user_id])
        respond_to do |format|
            format.turbo_stream{render turbo_stream: turbo_stream.update("change_password_form",partial: "/general_features/change_password", locals:{user_id: @user.id})}
        end
    end

    def change_password_proceed
        user = User.find(params[:user_id])
        respond_to do |format|
            if user.authenticate(params[:old_password])
                if params[:new_password] == params[:confirm_password]
                    user.password_digest = params[:new_password]
                    user.password_digest = BCrypt::Password.create(user.password_digest)
                    user.save
                    format.html{redirect_to "/account_details/profile", notice: "Successfully changed password!"}
                else
                    format.turbo_stream{render turbo_stream: turbo_stream.update("change_errMsg", "New Password did not match!")}
                end
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("change_errMsg", "Incorrect Old Password!")}
            end
        end
    end

end
