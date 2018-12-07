require 'httparty'

module AnswersEngine
  module Client
    class Base
      include HTTParty    
      base_uri(ENV['ANSWERSENGINE_API_URL'].nil? ? 'https://fetch.answersengine.com/api/v1' : ENV['ANSWERSENGINE_API_URL'])
      AUTH_TOKEN = ENV['ANSWERSENGINE_TOKEN']

      def initialize(opts={})
        @options = { headers: {
          "Authorization" => "Bearer #{AUTH_TOKEN}", 
          "Content-Type" => "application/json",
          }}

        query = {}
        query[:p] = opts[:page] if opts[:page]
        query[:pp] = opts[:per_page] if opts[:per_page]
        query[:fetchfail] = opts[:fetch_fail] if opts[:fetch_fail]
        query[:parsefail] = opts[:parse_fail] if opts[:parse_fail]
        
        if opts[:query]
          if opts[:query].is_a?(Hash)
            query[:q] = opts[:query].to_json
          elsif opts[:query].is_a?(String)
            query[:q] = JSON.parse(opts[:query]).to_json
          end
        end

        unless query.empty? 
          @options.merge!(query: query)
        end
      end
    end
  end
end
