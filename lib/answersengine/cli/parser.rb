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
        puts AnswersEngine::Scraper::Parser.try_parser_page(parser_file, gid, job_id)
      end
    end
  end

end
