module AnswersEngine
  module Client
    class ScraperJob < AnswersEngine::Client::Base
      def all(scraper_id, opts={})
        self.class.get("/scrapers/#{scraper_id}/jobs", @options)
      end
    end
  end
end

