class ApplicationController < ActionController::Base

    def is_logged_in
        if !session[:user_id].present?
            redirect_to "/login"
        end
    end

    def is_subscribed
        if session[:user_status] == "UNSUBSCRIBED"
            redirect_to session[:prev_url]
        end
    end

    def set_current_url
        session[:prev_url] = request.original_url
    end

    def checkUserUnsubscriptionDate
        user = User.find(session[:user_id])
        if user.unsubscriptionDate != nil
            if Date.today() >= user.unsubscriptionDate
                user.status = "UNSUBSCRIBED"
                session[:user_status] = user.status
                user.unsubscriptionDate = nil
                user.save
                redirect_to "account_details/subscribe"
            end
        end
    end

    def checkUserRenewalDate
        user = User.find(session[:user_id])
        if user.renewDate != nil
            if Date.today() >= user.renewDate
                puts "hello world"
                subscription = Subscription.new
                subscription.user_id = user.id
                subscription.payment = 60
                subscription.dateOfPayment = user.renewDate
                subscription.save
                user.status = "SUBSCRIBED"
                user.renewDate = user.renewDate + 30
                user.unsubscriptionDate = nil
                session[:user_status]= user.status
                user.save
            end
        end
    end
end
