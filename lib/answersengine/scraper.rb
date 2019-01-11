require "answersengine/scraper/parser"
require "answersengine/scraper/seeder"
require "answersengine/scraper/executor"
require "answersengine/scraper/ruby_parser_executor"
require "answersengine/scraper/ruby_seeder_executor"
require "answersengine/client"

module AnswersEngine
  module Scraper
    # def self.list(opts={})
    #   scraper = Client::Scraper.new(opts)
    #   "Listing scrapers #{ENV['ANSWERSENGINE_TOKEN']} for #{scraper.all}"
    # end
  end
end
