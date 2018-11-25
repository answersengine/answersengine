module AnswersEngine
  module Client
    class ScraperJob < AnswersEngine::Client::Base
      def all(scraper_name, opts={})
        self.class.get("/scrapers/#{scraper_name}/jobs", @options)
      end

      def create(scraper_name, opts={})
        body = {}
        body[:worker_count] = opts[:workers] if opts[:workers]
        @options.merge!({body: body.to_json})
        self.class.post("/scrapers/#{scraper_name}/jobs", @options)
      end
    end
  end
end

