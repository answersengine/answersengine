module AnswersEngine
  module Client
    class ScraperDeployment < AnswersEngine::Client::Base

      def all(scraper_id, opts={})
        self.class.get("/scrapers/#{scraper_id}/deployments", @options)
      end


      def deploy(scraper_id, opts={})
        self.class.post("/scrapers/#{scraper_id}/deployments", @options)
      end

    end
  end
end

