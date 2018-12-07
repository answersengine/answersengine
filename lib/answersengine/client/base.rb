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
        query[:q] = JSON.parse(opts[:query]).to_json if opts[:query]

        unless query.empty? 
          @options.merge!(query: query)
        end
      end
    end
  end
end
