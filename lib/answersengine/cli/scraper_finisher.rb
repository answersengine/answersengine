module AnswersEngine
  class CLI < Thor
    class ScraperFinisher < Thor

      package_name "scraper finisher"
      def self.banner(command, namespace = nil, subcommand = false)
        "#{basename} #{@package_name} #{command.usage}"
      end

      desc "reset <scraper_name>", "Reset finisher on a scraper's current job"
      long_desc <<-LONGDESC
        Reset finisher on a scraper's current job.\x5
      LONGDESC
      def reset(scraper_name)
        client = Client::ScraperFinisher.new(options)
        puts "#{client.reset(scraper_name)}"
      end
    end
  end
end
