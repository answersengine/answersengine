module AnswersEngine
  module Client
    class ScraperVar < AnswersEngine::Client::Base

      def find(scraper_name, var_name)
        self.class.get("/scrapers/#{scraper_name}/vars/#{var_name}", @options)
      end

      def all(scraper_name, opts={})
        params = @options.merge opts
        self.class.get("/scrapers/#{scraper_name}/vars", params)
      end

      def set(scraper_name, var_name, value, opts={})
        body = {}
        body[:value] = value
        body[:secret] = opts[:secret] if opts[:secret]
        params = @options.merge({body: body.to_json})
        self.class.put("/scrapers/#{scraper_name}/vars/#{var_name}", params)
      end

      def unset(scraper_name, var_name, opts={})
        params = @options.merge(opts)
        self.class.delete("/scrapers/#{scraper_name}/vars/#{var_name}", params)
      end
    end
  end
end
