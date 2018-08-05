module AnswersEngine
  class CLI < Thor
    
    desc "hello NAME", "Test hello world"
    def hello(name)
      puts AnswersEngine::Scraper::Parser.hello(name)
    end

  end
end