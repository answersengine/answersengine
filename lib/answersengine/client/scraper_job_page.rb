module AnswersEngine
  module Client
    class ScraperJobPage < AnswersEngine::Client::Base
      def find(scraper_name, gid)
        self.class.get("/scrapers/#{scraper_name}/current_job/pages/#{gid}", @options)
      end

      def all(scraper_name, opts={})
        self.class.get("/scrapers/#{scraper_name}/current_job/pages", @options)
      end

      def update(scraper_name, gid, opts={})
        body = {}        
        body[:page_type] = opts[:page_type] if opts[:page_type]
        body[:priority] = opts[:priority] if opts[:priority]
        body[:vars] = opts[:vars] if opts[:vars]
        
        @options.merge!({body: body.to_json})

        self.class.put("/scrapers/#{scraper_name}/current_job/pages/#{gid}", @options)
      end

    def reset(scraper_name, gid, opts={})
        self.class.put("/scrapers/#{scraper_name}/current_job/pages/#{gid}/reset", @options)
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
        
        @options.merge!({body: body.to_json})

        self.class.post("/scrapers/#{scraper_name}/current_job/pages", @options)
      end

    end
  end
end

