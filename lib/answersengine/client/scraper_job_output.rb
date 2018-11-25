module AnswersEngine
  module Client
    class ScraperJobOutput < AnswersEngine::Client::Base
      def find(scraper_name, collection, id)
        self.class.get("/scrapers/#{scraper_name}/current_job/output/collections/#{collection}/records/#{id}", @options)
      end

      def all(scraper_name, collection = 'default')

        self.class.get("/scrapers/#{scraper_name}/current_job/output/collections/#{collection}/records", @options)
      end

      def collections(scraper_name)
        self.class.get("/scrapers/#{scraper_name}/current_job/output/collections", @options)
      end
    end
  end
end

