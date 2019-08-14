module AnswersEngine
  module Client
    class Scraper < AnswersEngine::Client::Base

      def find(scraper_name)
        self.class.get("/scrapers/#{scraper_name}", @options)
      end

      def all(opts={})
        params = @options.merge opts
        self.class.get("/scrapers", params)
      end

      def create(scraper_name, git_repository, opts={})
        body = {}
        body[:name] = scraper_name
        body[:git_repository] = git_repository
        body[:git_branch] = opts[:branch] || opts[:git_branch] || "master" if opts[:branch] || opts[:git_branch]
        body[:freshness_type] = opts[:freshness_type] if opts[:freshness_type]
        body[:force_fetch] = opts[:force_fetch] if opts[:force_fetch]
        body[:standard_worker_count] = opts[:workers] || opts[:standard_worker_count] if opts[:workers] || opts[:standard_worker_count]
        body[:browser_worker_count] = opts[:browsers] || opts[:browser_worker_count] if opts[:browsers] || opts[:browser_worker_count]
        body[:proxy_type] = opts[:proxy_type] if opts[:proxy_type]
        body[:disable_scheduler] = opts[:disable_scheduler] if opts[:disable_scheduler]
        body[:cancel_current_job] = opts[:cancel_current_job] if opts[:cancel_current_job]
        body[:schedule] = opts[:schedule] if opts[:schedule]
        body[:timezone] = opts[:timezone] if opts[:timezone]
        params = @options.merge({body: body.to_json})
        self.class.post("/scrapers", params)
      end

      def update(scraper_name, opts={})
        body = {}
        body[:name] = opts[:name] if opts[:name]
        body[:git_repository] = opts[:repo] || opts[:git_repository] if opts[:repo] || opts[:git_repository]
        body[:git_branch] = opts[:branch] || opts[:git_branch] if opts[:branch] || opts[:git_branch]
        body[:freshness_type] = opts[:freshness_type] if opts[:freshness_type]
        body[:force_fetch] = opts[:force_fetch] if opts.has_key?("force_fetch") || opts.has_key?(:force_fetch)
        body[:standard_worker_count] = opts[:workers] || opts[:standard_worker_count] if opts[:workers] || opts[:standard_worker_count]
        body[:browser_worker_count] = opts[:browsers] || opts[:browser_worker_count] if opts[:browsers] || opts[:browser_worker_count]
        body[:proxy_type] = opts[:proxy_type] if opts[:proxy_type]
        body[:disable_scheduler] = opts[:disable_scheduler] if opts.has_key?("disable_scheduler") || opts.has_key?(:disable_scheduler)
        body[:cancel_current_job] = opts[:cancel_current_job] if opts.has_key?("cancel_current_job") || opts.has_key?(:cancel_current_job)
        body[:schedule] = opts[:schedule] if opts[:schedule]
        body[:timezone] = opts[:timezone] if opts[:timezone]
        params = @options.merge({body: body.to_json})

        self.class.put("/scrapers/#{scraper_name}", params)
      end

      def delete(scraper_name, opts={})
        params = @options.merge(opts)
        self.class.delete("/scrapers/#{scraper_name}", params)
      end
    end
  end
end
