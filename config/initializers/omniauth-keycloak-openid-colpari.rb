require 'omniauth'
require 'omniauth-oauth2'
require 'json/jwt'
require 'uri'

module OmniAuth
    module Strategies
        class KeycloakOpenIdColpari < OmniAuth::Strategies::KeycloakOpenId
            def callback_url
                result = full_host + script_name + callback_path
                Rails.logger.info " CBU: #{result}"
                result
            end
        end
    end
end
