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
        puts AnswersEngine::Scraper.list(options)
      end
    end
  end

end
