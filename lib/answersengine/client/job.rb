module AnswersEngine
  module Client
    class Job < AnswersEngine::Client::Base
      def all(opts={})
        self.class.get("/jobs", @options)
      end
    end

  end
end

