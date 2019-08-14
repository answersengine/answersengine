module AnswersEngine
  module Client
    class ScraperExporter < AnswersEngine::Client::Base
      def all(scraper_name, opts={})
        params = @options.merge(opts)
        self.class.get("/scrapers/#{scraper_name}/exporters", params)
      end

      def find(scraper_name, exporter_name)
        self.class.get("/scrapers/#{scraper_name}/exporters/#{exporter_name}", @options)
      end
    end
  end
end
