module AnswersEngine
  module Client
    class GlobalPage < AnswersEngine::Client::Base
      def find(gid)
        self.class.get("/global_pages/#{gid}", @options)
      end
    end
  end
end

