module AnswersEngine
  module Client
    class Export < AnswersEngine::Client::Base
      def all(opts={})
        params = @options.merge(opts)
        self.class.get("/scrapers/exports", params)
      end
    end
  end
end
