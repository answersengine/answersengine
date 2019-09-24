module AnswersEngine
  module Client
    class ScraperFinisher < AnswersEngine::Client::Base
      # Reset finisher on a scraper's current job.
      #
      # @param [String] scraper_name Scraper name.
      # @param [Hash] opts ({}) API custom parameters.
      #
      # @return [HTTParty::Response]
      def reset(scraper_name, opts={})
        params = @options.merge(opts)
        self.class.put("/scrapers/#{scraper_name}/current_job/finisher/reset", params)
      end
    end
  end
end
