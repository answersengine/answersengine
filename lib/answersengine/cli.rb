require 'thor'
require 'answersengine/scraper'
require 'answersengine/cli/scraper_job'
require 'answersengine/cli/page'
require 'answersengine/cli/job'
require 'answersengine/cli/scraper_deployment'
require 'answersengine/cli/scraper'


module AnswersEngine
  class CLI < Thor
    desc "scraper SUBCOMMAND ...ARGS", "manage scrapers"
    subcommand "scraper", Scraper

    desc "job SUBCOMMAND ...ARGS", "manage scrapers jobs"
    subcommand "job", Job

    desc "page SUBCOMMAND ...ARGS", "manage pages on a job"
    subcommand "page", Page

  end
end