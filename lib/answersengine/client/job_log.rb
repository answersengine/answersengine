module AnswersEngine
  module Client
    class JobLog < AnswersEngine::Client::Base
      def all_job_page_log(job_id, gid, opts={})
        params = @options.merge(opts)
        self.class.get("/jobs/#{job_id}/pages/#{gid}/log", params)
      end

      def scraper_all_job_page_log(scraper_name, gid, opts={})
        params = @options.merge(opts)
        self.class.get("/scrapers/#{scraper_name}/current_job/pages/#{gid}/log", params)
      end

      def all_job_log(job_id, opts={})
        params = @options.merge(opts)
        self.class.get("/jobs/#{job_id}/log", params)
      end

      def scraper_all_job_log(scraper_name, opts={})
        params = @options.merge(opts)
        self.class.get("/scrapers/#{scraper_name}/current_job/log", params)
      end

    end
  end
end
