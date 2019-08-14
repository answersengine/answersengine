module AnswersEngine
  module Client
    class ScraperJobPage < AnswersEngine::Client::Base
      def find(scraper_name, gid)
        self.class.get("/scrapers/#{scraper_name}/current_job/pages/#{gid}", @options)
      end

      def all(scraper_name, opts={})
        params = @options.merge(opts)
        self.class.get("/scrapers/#{scraper_name}/current_job/pages", params)
      end

      def update(scraper_name, gid, opts={})
        body = {}
        body[:page_type] = opts[:page_type] if opts[:page_type]
        body[:priority] = opts[:priority] if opts[:priority]
        body[:vars] = opts[:vars] if opts[:vars]

        params = @options.merge({body: body.to_json})

        self.class.put("/scrapers/#{scraper_name}/current_job/pages/#{gid}", params)
      end

      def refetch(scraper_name, opts={})
        params = @options.merge(opts)
        self.class.put("/scrapers/#{scraper_name}/current_job/pages/refetch", params)
      end

      def reparse(scraper_name, opts={})
        params = @options.merge(opts)
        self.class.put("/scrapers/#{scraper_name}/current_job/pages/reparse", params)
      end

      def enqueue(scraper_name, method, url, opts={})
        body = {}
        body[:method] =  method != "" ? method : "GET"
        body[:url] =  url
        body[:page_type] = opts[:page_type] if opts[:page_type]
        body[:priority] = opts[:priority] if opts[:priority]
        body[:fetch_type] = opts[:fetch_type] if opts[:fetch_type]
        body[:body] = opts[:body] if opts[:body]
        body[:headers] = opts[:headers] if opts[:headers]
        body[:vars] = opts[:vars] if opts[:vars]
        body[:force_fetch] = opts[:force_fetch] if opts[:force_fetch]
        body[:freshness] = opts[:freshness] if opts[:freshness]
        body[:ua_type] = opts[:ua_type] if opts[:ua_type]
        body[:no_redirect] = opts[:no_redirect] if opts[:no_redirect]
        body[:cookie] = opts[:cookie] if opts[:cookie]

        params = @options.merge({body: body.to_json})

        self.class.post("/scrapers/#{scraper_name}/current_job/pages", params)
      end

    end
  end
end
