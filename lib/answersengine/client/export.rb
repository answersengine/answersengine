module AnswersEngine
  module Client
    class Export < AnswersEngine::Client::Base
      def all(opts={})
        self.class.get("/scrapers/exports", @options)
      end
    end
  end
end

