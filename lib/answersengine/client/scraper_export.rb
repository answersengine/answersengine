module AnswersEngine
  module Client
    class ScraperExport < AnswersEngine::Client::Base
      def all(scraper_name, opts={})
        params = @options.merge(opts)
        self.class.get("/scrapers/#{scraper_name}/exports", params)
      end

      def find(export_id)
        self.class.get("/scrapers/exports/#{export_id}", @options)
      end

      def create(scraper_name, exporter_name)
        self.class.post("/scrapers/#{scraper_name}/exports/#{exporter_name}", @options)
      end

      def download(export_id)
        self.class.get("/scrapers/exports/#{export_id}/download", @options)
      end
    end
  end
end
