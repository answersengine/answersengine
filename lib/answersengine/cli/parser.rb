module AnswersEngine
  class CLI < Thor
    class Parser < Thor
      desc "try <parser_file> <GID>", "Tries a parser on a Global Page or Job Page"
      long_desc <<-LONGDESC
            Takes a parser script and runs it against a global page or a job page\n
            
            
            <parser_file>: Which parser script file will be executed on the page.\n
            
            <GID>: Global ID of the page.\x5
            
            With --job or -j option to set job_id to run this against a job page\n
            
            Example Usage: \x5
            answersengine parser try index.rb www.ebay.com-b3cc6226318ba6ba8e4a268341490fb35df24f141d95d9ebfccf8ffdd86ab364\x5
            answersengine parser try index.rb www.ebay.com-b3cc6226318ba6ba8e4a268341490fb35df24f141d95d9ebfccf8ffdd86ab364 --job 123\n
          LONGDESC
      option :job, :aliases => :j
      def try_parse(parser_file, gid)
        job_id = options[:job]
        puts AnswersEngine::Scraper::Parser.exec_parser_page(parser_file, gid, job_id, false)
      end

      desc "exec <job_id> <parser_file> <GID>...<GID>", "Executes a parser script on or more Job Pages"
      long_desc <<-LONGDESC
            Takes a parser script executes it against a job page and save the output to the job\n
            
            <job_id>: Global ID of the page.\x5
            <parser_file>: Which parser script file will be executed on the page.\x5
            
            <GID>: Global ID of the page.\x5
            
            Example Usage: \x5
            answersengine parser exec 123 index.rb www.ebay.com-b3cc6226318ba6ba8e4a268341490fb35df24f141d95d9ebfccf8ffdd86ab364\n
            answersengine parser exec 123 index.rb www.ebay.com-b3cc6226318ba6ba8e4a268341490fb35df24f141d95d9ebfccf8ffdd86ab364 www.ebay.com-b3cc6226318ba6ba8e4a268341490fb35df24f141d95d9ebfccf8ffdd86ab364\n
          LONGDESC
      def exec_parse(job_id, parser_file, *gids)
        gids.each do |gid|
          begin
            puts "Parsing #{gid}"
            puts AnswersEngine::Scraper::Parser.exec_parser_page(parser_file, gid, job_id, true)
          rescue => e
            puts e
          end
        end
      end
    end
  end

end
