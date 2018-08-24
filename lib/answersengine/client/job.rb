module AnswersEngine
  module Client
    class Job < AnswersEngine::Client::Base
      def all(opts={})
        self.class.get("/scrapers/#{id}/jobs", @options)
      end
    end
  end
end

