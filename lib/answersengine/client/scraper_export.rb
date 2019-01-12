module AnswersEngine
  module Client
    class ScraperExport < AnswersEngine::Client::Base
      def all(scraper_name, opts={})
        self.class.get("/scrapers/#{scraper_name}/exports", @options)
      end

      def find(export_id)
        self.class.get("/scrapers/exports/#{export_id}", @options)
      end

      def download(export_id)
        self.class.get("/scrapers/exports/#{export_id}/download", @options)
      end
    end
  end
end

