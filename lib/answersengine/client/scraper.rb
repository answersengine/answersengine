module AnswersEngine
  module Client
    class Scraper < AnswersEngine::Client::Base
      def all(opts={})
        self.class.get("/scrapers", @options)
      end
    end
  end
end

