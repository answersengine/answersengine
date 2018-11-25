module AnswersEngine
  class CLI < Thor
    class Scraper < Thor
      desc "parse <parser_type> <parser_file> <GID>", "Executes a parser file on a page"
      long_desc <<-LONGDESC
            Takes a page and executes the parser file based on what parser type.\n
            
            <parser_type>: Determines what kind of parser will be executed. Available options: "ruby" or "config"\n
            
            <parser_file>: Which parser file will be executed on the page.\n
            
            <GID>: Global ID of the page.\n
            
            Example Usage: \n
            answersengine scraper parse ruby index.rb www.ebay.com-b3cc6226318ba6ba8e4a268341490fb35df24f141d95d9ebfccf8ffdd86ab364\n
            answersengine scraper parse config index.json www.ebay.com-b3cc6226318ba6ba8e4a268341490fb35df24f141d95d9ebfccf8ffdd86ab364
          LONGDESC
      def parse(parser_type, parser_file, gid)
        puts AnswersEngine::Scraper::Parser.parse(parser_type, parser_file, gid)
      end

      desc "list", "List scrapers"
      option :page, :aliases => :p
      long_desc <<-LONGDESC
        List scrapers.
   
        With --page or -p option to get the next set of records by page.
      LONGDESC
      def list
        client = Client::Scraper.new(options)
        puts "#{client.all}"
      end

      desc "create <scraper_name> <git_repository>", "Create a scraper"
      long_desc <<-LONGDESC
          Creates a scraper\x5
          With --branch or -b option to set the branch. Defaults to master.\x5
          With --freshness-type or -t option to set day|week|month|year|any. Defaults to any\x5
          With --force-fetch or -f option to set true or false, defaults to false .\x5
          With --workers or -w option to set how many workers to use. Defaults to 1.
          LONGDESC
      option :branch, :aliases => :b
      option :freshness_type, :aliases => :t
      option :force_fetch, :aliases => :f, type: :boolean
      option :workers, :aliases => :w, type: :numeric
      def create(scraper_name, git_repository)
        client = Client::Scraper.new(options)
        puts "#{client.create(scraper_name, git_repository, options)}"
      end

      desc "update <scraper_name>", "Update a scraper"
      long_desc <<-LONGDESC
          Updates a scraper\x5
          With --name or -n option to set the scraper name.\x5
          With --branch or -b option to set the branch name.\x5
          With --repo or -r option to set the git repo.\x5
          With --freshness-type or -t option to set day|week|month|year|any. Defaults to any \x5
          With --force-fetch or -f option to set true or false, defaults to false . \x5
          With --workers or -w option to set how many workers to use. Defaults to 1.
          LONGDESC
      option :branch, :aliases => :b
      option :name, :aliases => :n
      option :repo, :aliases => :r
      option :freshness_type, :aliases => :t
      option :force_fetch, :aliases => :f, type: :boolean
      option :workers, :aliases => :w, type: :numeric
      def update(scraper_name)
        client = Client::Scraper.new(options)
        puts "#{client.update(scraper_name, options)}"
      end


      desc "show <scraper_name>", "Show a scraper"
      def show(scraper_name)
        client = Client::Scraper.new(options)
        puts "#{client.find(scraper_name)}"
      end

      desc "deploy <scraper_name>", "Deploy a scraper"
      long_desc <<-LONGDESC
          Deploys a scraper
          LONGDESC
      def deploy(scraper_name)
        client = Client::ScraperDeployment.new()
        puts "Deploying scraper. This may take a while..."
        puts "#{client.deploy(scraper_name)}"
      end

      desc "start <scraper_name>", "Starts a scraper"
      long_desc <<-LONGDESC
          Starts a scraper by crating an active scrape job\x5
          With --workers or -w option to set how many workers to use. Defaults to 1.
          LONGDESC
      option :workers, :aliases => :w, type: :numeric
      def start(scraper_name)
        client = Client::ScraperJob.new(options)
        puts "Starting a scrape job..."
        puts "#{client.create(scraper_name, options)}"
      end

      desc "job SUBCOMMAND ...ARGS", "manage scrapers jobs"
      subcommand "job", ScraperJob

      desc "deployment SUBCOMMAND ...ARGS", "manage scrapers deployments"
      subcommand "deployment", ScraperDeployment
    end
  end

end
