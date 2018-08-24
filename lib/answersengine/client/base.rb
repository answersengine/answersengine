require 'httparty'

module AnswersEngine
  module Client
    class Base
      include HTTParty    
      base_uri 'localhost:8080/api/v1'  
      AUTH_TOKEN = ENV['ANSWERSENGINE_TOKEN']

      def initialize()
        @options = { headers: {"Authorization" => "Bearer #{AUTH_TOKEN}"}}
      end
    end
  end
end
