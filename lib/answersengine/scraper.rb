require "answersengine/scraper/parser"
require "answersengine/client"

module AnswersEngine
  module Scraper
    def self.list(page=1)
      scraper = Client::Scraper.new
      "Listing scrapers #{ENV['ANSWERSENGINE_TOKEN']} for #{scraper.all(page)}"

    end
  end
end
