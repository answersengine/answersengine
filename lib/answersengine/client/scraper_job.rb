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

      def find(scraper_name)
        self.class.get("/scrapers/#{scraper_name}/current_job", @options)
      end

      def update(scraper_name, opts={})
        body = {}
        body[:status] = opts[:status] if opts[:status]
        body[:worker_count] = opts[:workers] if opts[:workers]
        @options.merge!({body: body.to_json})

        self.class.put("/scrapers/#{scraper_name}/current_job", @options)
      end

      def cancel(scraper_name, opts={})
        opts[:status] = 'cancelled'
        update(scraper_name, opts)
      end

      def resume(scraper_name, opts={})
        opts[:status] = 'active'
        update(scraper_name, opts)
      end

      def pause(scraper_name, opts={})
        opts[:status] = 'paused'
        update(scraper_name, opts)
      end
    end
  end
end

