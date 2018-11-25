module AnswersEngine
  module Client
    class JobLog < AnswersEngine::Client::Base
      def all_job_page_log(job_id, gid, opts={})
        @options.merge!(opts)
        self.class.get("/jobs/#{job_id}/pages/#{gid}/log", @options)
      end

      def scraper_all_job_page_log(scraper_name, gid, opts={})
        @options.merge!(opts)
        self.class.get("/scrapers/#{scraper_name}/current_job/pages/#{gid}/log", @options)
      end

      def all_job_log(job_id, opts={})
        @options.merge!(opts)
        self.class.get("/jobs/#{job_id}/log", @options)
      end

      def scraper_all_job_log(scraper_name, opts={})
        @options.merge!(opts)
        self.class.get("/scrapers/#{scraper_name}/current_job/log", @options)
      end

    end
  end
end

