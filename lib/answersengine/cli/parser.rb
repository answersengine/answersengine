module AnswersEngine
  class CLI < Thor
    class Parser < Thor
      desc "try <parser_file> <GID>", "Tries a parser on a Global Page or Job Page"
      long_desc <<-LONGDESC
            Takes a parser script and runs it against a global page or a job page\x5
            <parser_file>: Parser script file that will be executed on the page.\x5
            <GID>: Global ID of the page.\x5
          LONGDESC
      option :job, :aliases => :j, type: :numeric, desc: 'Set a specific job ID'
      option :scraper, :aliases => :s, desc: 'Set a specific scraper name'
      option :vars, :aliases => :v, type: :string, desc: 'Set user-defined page variables. Must be in json format. i.e: {"Foo":"bar"}'
      def try_parse(parser_file, gid)
        begin 
          
          if options[:scraper]
            job = Client::ScraperJob.new(options).find(options[:scraper])
            job_id = job['id']
          elsif options[:job]
            job_id = options[:job]
          end

          vars = JSON.parse(options[:vars]) if options[:vars]
          puts AnswersEngine::Scraper::Parser.exec_parser_page(parser_file, gid, job_id, false, vars)

          rescue JSON::ParserError
          if options[:vars]
            puts "Error: #{options[:vars]} on vars is not a valid JSON"
          end
        end
      end

      desc "exec <scraper_name> <parser_file> <GID>...<GID>", "Executes a parser script on one or more Job Pages within a scraper's current job"
      long_desc <<-LONGDESC
            Takes a parser script executes it against a job page(s) and save the output to the scraper's current job\x5
            <parser_file>: Parser script file will be executed on the page.\x5
            <GID>: Global ID of the page.\x5
          LONGDESC
      option :job, :aliases => :j, type: :numeric, desc: 'Set a specific job ID'
      def exec_parse(scraper_name, parser_file, *gids)
        gids.each do |gid|
          begin
            puts "Parsing #{gid}"

            if options[:job]
              job_id = options[:job]
            else
              job = Client::ScraperJob.new(options).find(scraper_name)
              job_id = job['id']
            end

            puts AnswersEngine::Scraper::Parser.exec_parser_page(parser_file, gid, job_id, true)
          rescue => e
            puts e
          end
        end
      end
    end
  end

end
