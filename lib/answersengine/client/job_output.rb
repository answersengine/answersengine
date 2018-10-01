module AnswersEngine
  module Client
    class JobOutput < AnswersEngine::Client::Base
      def find(job_id, collection, id)
        self.class.get("/jobs/#{job_id}/output/collections/#{collection}/records/#{id}", @options)
      end

      def all(job_id, collection = 'default')

        self.class.get("/jobs/#{job_id}/output/collections/#{collection}/records", @options)
      end

      def collections(job_id)
        self.class.get("/jobs/#{job_id}/output/collections", @options)
      end
    end
  end
end

