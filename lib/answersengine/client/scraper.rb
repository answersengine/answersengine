module AnswersEngine
  module Client
    class Scraper < AnswersEngine::Client::Base
      def all(opts={})
        query = {}
        query[:page] = opts[:page] if opts[:page]

        unless query.empty? 
          @options.merge!(query: query)
        end

        self.class.get("/scrapers", @options)
      end
    end
  end
end

