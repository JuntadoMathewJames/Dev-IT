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
                    if user.status == "UNSUBSCRIBED"
                        format.html{redirect_to "/subscribe"}
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
                    format.html{redirect_to "/subscribe"}
                else
                    format.turbo_stream{render turbo_stream: turbo_stream.update("register_errorArea", "<p style = 'color:red;'><strong>Passwords did not match!</strong></p>")}
                end
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("register_errorArea",partial: "/layouts/errorMessage", locals:{entity: @user})}
            end
        end
    end

    def subscribe
        @subscription = Subscription.new
    end

    def subscribe_proceed
        @subscription = Subscription.new
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
                format.html{redirect_to "/pos"}
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("errorArea","<p style = 'color:red;'><strong>Incorrect Password!</strong></p>")}
            end
        end
    end

end
