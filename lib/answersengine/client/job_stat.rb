module AnswersEngine
  module Client
    class JobStat < AnswersEngine::Client::Base

      def current(job_id)
        self.class.get("/jobs/#{job_id}/stats/current", @options)
      end

    end
  end
end

