module AnswersEngine
  module Client
    class Scraper < AnswersEngine::Client::Base

      def find(scraper_id)
        self.class.get("/scrapers/#{scraper_id}", @options)
      end

      def all(opts={})
        self.class.get("/scrapers", @options)
      end

      def create(name, git_repository, opts={})
        @options.merge!({body: {
            name: name,
            git_repository: git_repository,
            git_branch: opts[:branch] ? opts[:branch] : "master"}.to_json
          })
        self.class.post("/scrapers", @options)
      end
    end
  end
end

