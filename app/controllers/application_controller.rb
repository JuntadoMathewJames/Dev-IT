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
end
