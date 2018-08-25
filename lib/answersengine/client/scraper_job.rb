module AnswersEngine
  module Client
    class ScraperJob < AnswersEngine::Client::Base
      def all(scraper_id, opts={})
        self.class.get("/scrapers/#{scraper_id}/jobs", @options)
      end

      def create(scraper_id, opts={})
        @options.merge!({body:{}.to_json})
        self.class.post("/scrapers/#{scraper_id}/jobs", @options)
      end
    end
  end
end

