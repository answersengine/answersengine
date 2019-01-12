module AnswersEngine
  module Client
    class JobExport < AnswersEngine::Client::Base
      def create(job_id, exporter_name)
        self.class.post("/jobs/#{job_id}/exports/#{exporter_name}", @options)
      end
    end
  end
end

