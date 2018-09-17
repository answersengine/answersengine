module AnswersEngine
  class CLI < Thor
    class Parser < Thor
      desc "try <parser_file> <GID>", "Tries a parser on a Global Page"
      long_desc <<-LONGDESC
            Takes a global page and tries running the parser script on the page\n
            
            
            <parser_file>: Which parser script file will be executed on the page.\n
            
            <GID>: Global ID of the page.\n
            
            Example Usage: \n
            answersengine parser try index.rb www.ebay.com-b3cc6226318ba6ba8e4a268341490fb35df24f141d95d9ebfccf8ffdd86ab364\n
          LONGDESC
      def try_parse(parser_file, gid)
        puts AnswersEngine::Scraper::Parser.parse(parser_file, gid)
      end
    end
  end

end
