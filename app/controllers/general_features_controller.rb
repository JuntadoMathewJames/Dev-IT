class GeneralFeaturesController < ApplicationController
    before_action :set_current_url, except:[:pos]
    before_action :is_subscribed, only: %i[pos]
    def index
    
    end

    def pos
      
    end

    def account_details
        @method = params[:method]
    end

end
