module AnswersEngine
  module Client
    class ScraperJob < AnswersEngine::Client::Base
      def all(scraper_name, opts={})
        params = @options.merge(opts)
        self.class.get("/scrapers/#{scraper_name}/jobs", params)
      end

      def create(scraper_name, opts={})
        body = {}
        body[:standard_worker_count] = opts[:workers] if opts[:workers]
        body[:browser_worker_count] = opts[:browsers] if opts[:browsers]
        body[:proxy_type] = opts[:proxy_type] if opts[:proxy_type]
        params = @options.merge({body: body.to_json})
        self.class.post("/scrapers/#{scraper_name}/jobs", params)
      end

      def find(scraper_name)
        self.class.get("/scrapers/#{scraper_name}/current_job", @options)
      end

      def update(scraper_name, opts={})
        body = {}
        body[:status] = opts[:status] if opts[:status]
        body[:standard_worker_count] = opts[:workers] if opts[:workers]
        body[:browser_worker_count] = opts[:browsers] if opts[:browsers]
        body[:proxy_type] = opts[:proxy_type] if opts[:proxy_type]
        params = @options.merge({body: body.to_json})

        self.class.put("/scrapers/#{scraper_name}/current_job", params)
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
