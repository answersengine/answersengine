module AnswersEngine
  class CLI < Thor
    class GlobalPage < Thor

      desc "show <gid>", "Show a page in job"
      def show(gid)
        client = Client::GlobalPage.new(options)
        puts "#{client.find(gid)}"
      end

    end
  end

end
