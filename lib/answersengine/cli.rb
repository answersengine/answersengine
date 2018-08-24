require 'thor'
require 'answersengine/scraper'
require 'answersengine/cli/scraper'
require 'answersengine/cli/job'

module AnswersEngine
  class CLI < Thor
    desc "scraper SUBCOMMAND ...ARGS", "manage scrapers"
    subcommand "scraper", Scraper
    # subcommand "scraper job", Job
  end
end