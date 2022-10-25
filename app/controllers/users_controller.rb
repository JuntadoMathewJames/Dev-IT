class UsersController < ApplicationController

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
                        format.html{redirect_to "/products"}
                    end
                else
                    format.turbo_stream{render turbo_stream: turbo_stream.update("errMsg", "<strong>INVALID PASSWORD!</strong>")}
                end
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("errMsg", "<strong>ACCOUNT NOT FOUND!</strong>")}
            end
        end
    end

    def register
        @user = User.new
    end

    def register_proceed
        user = User.new
        user.username = params[:username]
        user.password_digest = params[:password_digest]
        respond_to do |format|
            if user.password_digest == params[:confirm_password]
                user.status = "UNSUBSCRIBED"
                user.password_digest = BCrypt::Password.create(user.password_digest)
                if user.save
                    session[:user_id] = user.id
                    session[:user_status] = user.status
                    format.html{redirect_to "/subscribe"}
                else
                    format.turbo_stream{render turbo_stream: turbo_stream.update("errorArea",partial: "/layouts/errorMessage", locals:{entity: user})}
                end
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("errorArea", "<p style = 'color:red;'><strong>Passwords did not match!</strong></p>")}
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
                format.html{redirect_to "/products"}
            else
                format.turbo_stream{render turbo_stream: turbo_stream.update("errorArea","<p style = 'color:red;'><strong>Incorrect Password!</strong></p>")}
            end
        end
    end

end
