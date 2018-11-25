module AnswersEngine
  module Client
    class ScraperDeployment < AnswersEngine::Client::Base

      def all(scraper_name, opts={})
        self.class.get("/scrapers/#{scraper_name}/deployments", @options)
      end


      def deploy(scraper_name, opts={})
        self.class.post("/scrapers/#{scraper_name}/deployments", @options)
      end

    end
  end
end

