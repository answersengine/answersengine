require 'thor'
require 'answersengine/scraper'
require 'answersengine/cli/job'
require 'answersengine/cli/scraper'


module AnswersEngine
  class CLI < Thor
    desc "scraper SUBCOMMAND ...ARGS", "manage scrapers"
    subcommand "scraper", Scraper
  end
end