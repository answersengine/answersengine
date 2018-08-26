module AnswersEngine
  module Client
    class JobPage < AnswersEngine::Client::Base
      def find(job_id, gid)
        self.class.get("/jobs/#{job_id}/pages/#{gid}", @options)
      end

      def all(job_id, opts={})
        self.class.get("/jobs/#{job_id}/pages", @options)
      end
    end
  end
end

