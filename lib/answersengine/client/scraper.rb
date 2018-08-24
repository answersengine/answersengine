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

      def update(scraper_id, opts={})
        body = {}

        body[:name] = opts[:name] if opts[:name]
        body[:git_repository] = opts[:repo] if opts[:repo]
        body[:git_branch] = opts[:branch] if opts[:branch]
        @options.merge!({body: body.to_json})

        self.class.put("/scrapers/#{scraper_id}", @options)
      end


    end
  end
end

