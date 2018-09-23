module AnswersEngine
  module Client
    class JobPage < AnswersEngine::Client::Base
      def find(job_id, gid)
        self.class.get("/jobs/#{job_id}/pages/#{gid}", @options)
      end

      def all(job_id, opts={})
        self.class.get("/jobs/#{job_id}/pages", @options)
      end

      def update(job_id, gid, opts={})
        body = {}        
        body[:page_type] = opts[:page_type] if opts[:page_type]
        
        @options.merge!({body: body.to_json})

        self.class.put("/jobs/#{job_id}/pages/#{gid}", @options)
      end

      def enqueue(job_id, method, url, opts={})
        body = {}        
        body[:method] =  method != "" ? method : "GET"
        body[:url] =  url
        body[:page_type] = opts[:page_type] if opts[:page_type]
        body[:body] = opts[:body] if opts[:body]
        body[:headers] = opts[:headers] if opts[:headers]
        body[:force_fetch] = opts[:force_fetch] if opts[:force_fetch]
        body[:freshness] = opts[:freshness] if opts[:freshness]
        body[:ua_type] = opts[:ua_type] if opts[:ua_type]
        body[:no_redirect] = opts[:no_redirect] if opts[:no_redirect]
        
        @options.merge!({body: body.to_json})

        self.class.post("/jobs/#{job_id}/pages", @options)
      end

      def parsing_update(job_id, gid, opts={})
        body = {}
        body[:outputs] = opts.fetch(:outputs) {[]}
        body[:pages] = opts.fetch(:pages) {[]}
        body[:parsing_failed] = opts.fetch(:parsing_failed){ false }
        
        @options.merge!({body: body.to_json})

        self.class.put("/jobs/#{job_id}/pages/#{gid}/parsing_update", @options)
      end
    end
  end
end

