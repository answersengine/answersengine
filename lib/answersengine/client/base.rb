require 'httparty'

module AnswersEngine
  module Client
    class Base
      include HTTParty    
      base_uri 'localhost:8080/api/v1'  
      AUTH_TOKEN = ENV['ANSWERSENGINE_TOKEN']

      def initialize(opts={})
        @options = { headers: {"Authorization" => "Bearer #{AUTH_TOKEN}"}}

        query = {}
        query[:page] = opts[:page] if opts[:page]

        unless query.empty? 
          @options.merge!(query: query)
        end
      end
    end
  end
end
