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
    end
  end
end

